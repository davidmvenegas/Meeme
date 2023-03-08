import SwiftUI
import Amplify
import PhotosUI

struct HomeView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var imageModel: ImageModel
    
    @State var selectedPhotoPickerImages: [PhotosPickerItem] = []
    @State var selectedImages: [Image] = []
    @State var isAddingPhotos: Bool = false
    @State var searchText: String = ""
        
    let user: AuthUser
    // Button("Sign Out", action: sessionManager.signOut)

    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView() {
                    LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: 120, maximum: .infinity), spacing: 2), count: 3), spacing: 2) {
//                        ForEach(Images.allCases, id: \.self) { image in
//                            GridColumn(image: image, images: $selectedImages)
//                        }
                        ForEach(1..<50) { _ in
                            AsyncImage(url: URL(string: "https://picsum.photos/600")) {
                                image in image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    .clipped()
                                    .aspectRatio(1, contentMode: .fit)
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
                        PhotosPicker(selection: $selectedPhotoPickerImages, matching: .images) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 0)
                                    .fill(Color(.systemGray4))
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    .clipped()
                                    .aspectRatio(1, contentMode: .fit)
                                Image(systemName: "plus").font(.system(size: 22.5, weight: .medium))
                                    .accentColor(.white.opacity(0.8))
                            }
                        }
                    }
                }
                .listStyle(.inset)
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
                        }
                        label: {
                            Label("Add", systemImage: "ellipsis.circle")
                                .accentColor(Color(.white))
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: -2, bottom: 0, trailing: -2))
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Photos, People, Places..."
            )
        }
    }
}

//struct GridColumn: View {
//
//    let image: Image
//    @Binding var selectedImages: [Image]
//
//    var body: some View {
//        Button(action: {
//            if selectedImages.contains(image) {
//                selectedImages.removeAll {$0 == image}
//            } else {
//                selectedImages.append(image)
//            }
//        }, label: {
//            Text(image)
//                .tag(image)
//                .foregroundColor(selectedImages.contains(image) ? .purple : .white)
//        })
//        .frame(width: 85, height: 85)
//        .background(selectedImages.contains(image) ? Color.white : Color.purple)
//        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//    }
//}

//import SwiftUI
//import Amplify
//import PhotosUI
//
//struct HomeView: View {
//
//    @EnvironmentObject var sessionManager: SessionManager
//    @EnvironmentObject var imageModel: ImageModel
//
//    let user: AuthUser
//
//    @State var selectedPhotoPickerImages: [PhotosPickerItem] = []
//
//    @State private var isAddingPhoto = false
//    @State private var isEditing = false
//    @State private var searchText = ""
//
//
//    var body: some View {
//        ScrollView {
//            LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: .infinity), spacing: 3)], spacing: 3) {
//                ForEach(imageModel.meemeImages) { image in
//                    GeometryReader { geo in
//                        NavigationLink(destination: ImageView()) {
//                            GridImage(size: geo.size.width, image: image)
//                        }
//                    }
//                    .aspectRatio(1, contentMode: .fit)
//                    .overlay(alignment: .topTrailing) {
//                        if isEditing {
//                            Button {
//                                withAnimation {
//                                    imageModel.removeImage(image)
//                                }
//                            } label: {
//                                Image(systemName: "xmark.square.fill")
//                                    .font(Font.title)
//                                    .symbolRenderingMode(.palette)
//                                    .foregroundStyle(.white, .red)
//                            }
//                            .offset(x: 7, y: -7)
//                        }
//                    }
//                }
//            }
//        }
//        .navigationBarTitle("Meeme", displayMode: .large)
//        .navigationBarTitleDisplayMode(.inline)
//        .sheet(isPresented: $isAddingPhoto) {
//            PhotosPicker(selection: $selectedPhotoPickerImages, matching: .images) {
//                Text("Select Memes to Upload")
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(isEditing ? "Done" : "Edit") {
//                    withAnimation { isEditing.toggle() }
//                }
//            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    isAddingPhoto = true
//                } label: {
//                    Image(systemName: "plus")
//                }
//                .disabled(isEditing)
//            }
//        }
//    }
//}
//
//
//struct GridImage: View {
//    let size: Double
//    let image: MeemeImage
//
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            AsyncImage(url: image.url) { image in
//                image
//                    .resizable()
//                    .scaledToFill()
//            } placeholder: {
//                ProgressView()
//            }
//            .frame(width: size, height: size)
//
////            AsyncImage(url: URL(string: "https://picsum.photos/600")) {
////                image in image
////                    .resizable()
////                    .aspectRatio(contentMode: .fill)
////                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
////                    .clipped()
////                    .aspectRatio(1, contentMode: .fit)
////            } placeholder: {
////                ZStack {
////                    RoundedRectangle(cornerRadius: 0)
////                        .fill(.gray.opacity(0.5))
////                        .frame(height: 100)
////                    ProgressView()
////                }
////            }
//        }
//    }
//}
//
//
//
////    .searchable(
////        text: $searchText,
////        placement: .navigationBarDrawer(displayMode: .always),
////        prompt: "Photos, People, Places..."
////    )
//
//
//
////    .navigationBarTitle("Meeme", displayMode: .large)
////    .toolbar {
////        ToolbarItem(placement: .navigationBarTrailing) {
////            HStack {
////                Button(action: {}) {
////                    Text("Select").font(.system(size: 13.25, weight: .medium))
////                        .padding(EdgeInsets(top: -1.5, leading: 0, bottom: -1.5, trailing: 0))
////                }
////                .foregroundColor(.white)
////                .buttonStyle(.bordered)
////                .cornerRadius(20)
////            }
////        }
////        ToolbarItemGroup(placement: .navigationBarTrailing) {
////            Menu {
////               Button(action: {}) {
////                   Label("Create a file", systemImage: "doc")
////               }
////               Button(action: {}) {
////                   Label("Create a folder", systemImage: "folder")
////               }
////            }
////            label: {
////                Label("Add", systemImage: "ellipsis.circle")
////            }
////        }
////    }
