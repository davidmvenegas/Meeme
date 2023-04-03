import SwiftUI
import Amplify
import PhotosUI


struct HomeView: View {
    
    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var imageController: ImageController
    
    @Namespace private var gridNamespace
    @Namespace private var imageNamespace
    
    @State private var selectedPhotosPickerImages: [PhotosPickerItem] = []
    @State private var focusedImage: MeemeImage? = nil
    @State private var searchText: String = ""
    
    
    var body: some View {
        ZStack {
            GridView.opacity(focusedImage == nil ? 1 : 0)
            // DetailView goes here
        }
        .animation(.default, value: focusedImage)
    }
    
    
    @ViewBuilder
    var GridView: some View {
        ZStack {
            Color("appBackground").edgesIgnoringSafeArea(.all)
            NavigationView {
                ScrollView() {
                    LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: 120, maximum: .infinity), spacing: 2), count: 3), spacing: 2) {
                        ForEach(imageController.meemeImages) { meemeImage in
                            AsyncImage(url: meemeImage.url) {
                                image in image
                                    .resizable()
                                    .matchedGeometryEffect(
                                        id: meemeImage.id,
                                        in: gridNamespace,
                                        isSource: true
                                    )
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    .clipped()
                                    .aspectRatio(1, contentMode: .fit)
                                    .onTapGesture {
                                        focusedImage = meemeImage
                                    }
                            } placeholder: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 0)
                                        .fill(.gray.opacity(0.5))
                                        .aspectRatio(contentMode: .fill)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                        .clipped()
                                        .aspectRatio(1, contentMode: .fit)
                                    ProgressView()
                                }
                            }
                        }
                        PhotosPicker(selection: $selectedPhotosPickerImages, maxSelectionCount: 100, matching: .any(of: [.images, .not(.livePhotos)])) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 0)
                                    .fill(Color(.systemGray4))
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    .clipped()
                                    .aspectRatio(1, contentMode: .fit)
                                Image(systemName: "plus").font(.system(size: 23.5, weight: .medium))
                                    .accentColor(.white.opacity(0.8))
                            }
                        }
                        .onChange(of: selectedPhotosPickerImages) { newImages in
                            for newImage in newImages {
                                Task {
                                    if let imageData = try? await newImage.loadTransferable(type: Data.self) {
                                        await imageController.uploadMeemeImage(
                                            imageData: imageData,
                                            ownerId: GlobalState.shared.currentUser!.userId
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Meeme", displayMode: .large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button(action: {}) {
                                Text("Select").font(.system(size: 13, weight: .medium))
                                    .padding(EdgeInsets(top: -1.75, leading: 0, bottom: -1.75, trailing: 0))
                            }
                            .foregroundColor(.white)
                            .buttonStyle(.bordered)
                            .cornerRadius(14)
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: {}) {
                                Label("Action One", systemImage: "doc")
                            }
                            Button(action: {}) {
                                Label("Action Two", systemImage: "folder")
                            }
                            Button(action: {Task { await Amplify.Auth.signOut() }}) {
                                Label("Log out", systemImage: "")
                            }
                            .foregroundColor(.red)
                        }
                    label: {
                        Label("Menu", systemImage: "ellipsis.circle")
                            .accentColor(Color(.white))
                    }
                    }
                }
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Photos, People, Places..."
            )
            .zIndex(1)
        }
    }
}
