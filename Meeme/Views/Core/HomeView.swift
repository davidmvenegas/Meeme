import SwiftUI
import Amplify
import PhotosUI



struct TransitionIsActiveKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var transitionIsActive: Bool {
        get { self[TransitionIsActiveKey.self] }
        set { self[TransitionIsActiveKey.self] = newValue }
    }
}

struct TransitionReader<Content: View>: View {
    var content: (Bool) -> Content
    @Environment(\.transitionIsActive) var active
    
    var body: some View {
        content(active)
    }
}

struct TransitionActive: ViewModifier {
    var active: Bool
    
    func body(content: Content) -> some View {
        content
            .environment(\.transitionIsActive, active)
    }
}


struct HomeView: View {
    
    @EnvironmentObject var sessionModel: SessionModel
    @EnvironmentObject var imageModel: ImageModel
    
    @Namespace private var gridNamespace
    @Namespace private var imageNamespace
    
    @State private var selectedPhotosPickerImages: [PhotosPickerItem] = []
    @State private var selectedEditableImages: [MeemeImage] = []
    @State private var focusedImage: MeemeImage? = nil
    @State private var searchText: String = ""
    
    
    func uploadImageToCloud(imageSelected: PhotosPickerItem) {
        Task {
            if let imageData = try? await imageSelected.loadTransferable(type: Data.self) {
                await imageModel.handleUploadMeemeToCloud(imageData: imageData)
            }
        }
    }
    
    
    var body: some View {
        ZStack {
            GridView.opacity(focusedImage == nil ? 1 : 0)
            DetailView
        }
        .animation(.default, value: focusedImage)
    }
    
    
    // GRID VIEW
    @ViewBuilder
    var GridView: some View {
        ZStack {
            Color("appBackground").edgesIgnoringSafeArea(.all)
            NavigationView {
                ScrollView() {
                    LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: 120, maximum: .infinity), spacing: 2), count: 3), spacing: 2) {
                        ForEach(imageModel.meemeImages) { meemeImage in
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
                                        print("Hey")
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
                                uploadImageToCloud(imageSelected: newImage)
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
                                Label("Create a file", systemImage: "doc")
                            }
                            Button(action: {}) {
                                Label("Create a folder", systemImage: "folder")
                            }
                            Button(action: {Task { await Amplify.Auth.signOut() }}) {
                                Label("Log out", systemImage: "")
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.red)
                        }
                    label: {
                        Label("Add", systemImage: "ellipsis.circle")
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
    
    
    @ViewBuilder
    var DetailView: some View {
        if let meemeImage = focusedImage {
            ZStack {
                TransitionReader { active in
                    AsyncImage(url: URL(string: "https://hws.dev/paul.jpg")) {
                        image in image
                            .resizable()
                            .mask {
                                Rectangle().aspectRatio(1, contentMode: active ? .fit : .fill)
                            }
                            .matchedGeometryEffect(
                                id: meemeImage.id,
                                in: active ? gridNamespace : imageNamespace,
                                isSource: false
                            )
                            .aspectRatio(contentMode: .fit)
                            .onTapGesture {
                                self.focusedImage = nil
                            }
                    } placeholder: {
                        
                    }
                }
            }
            .zIndex(2)
            .id(meemeImage.id)
            .transition(
                .modifier(
                    active: TransitionActive(active: true),
                    identity: TransitionActive(active: false)
                )
            )
        }
    }
}
