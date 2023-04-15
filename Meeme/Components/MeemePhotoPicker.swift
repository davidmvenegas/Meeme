import PhotosUI
import SwiftUI

struct UploadProgress: Equatable {
    var current: Int
    var total: Int
}

struct MeemePhotoPicker: View {
    @EnvironmentObject var imageController: ImageController

    @State private var selectedPhotosPickerImages: [PhotosPickerItem] = []
    @State private var showCheckmarkAnimation: Bool = false
    @State private var uploadProgress: UploadProgress? = nil
    @State private var isUploading: Bool = false

    @State private var errorMessage: String = ""
    @State private var showError: Bool = false

    func handleUploadImages(imagesSelected: [PhotosPickerItem]) {
        let totalCount = imagesSelected.count
        var currentCount = 0

        uploadProgress = UploadProgress(current: currentCount, total: totalCount)

        for image in imagesSelected {
            Task {
                if let imageData = try? await image.loadTransferable(type: Data.self) {
                    isUploading = true
                    let uploadSuccess = await imageController.uploadImage(imageData: imageData)
                    if uploadSuccess {
                        currentCount += 1
                        uploadProgress?.current = currentCount
                        if currentCount == totalCount {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showCheckmarkAnimation = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                endUploadProcess()
                            }
                        }
                    } else {
                        endUploadProcess()
                        handleError(message: "Failed to upload image, please try again.")
                    }
                }
            }
        }
    }

    func endUploadProcess() {
        isUploading = false
        uploadProgress = nil
        showCheckmarkAnimation = false
        selectedPhotosPickerImages = []
    }

    func handleError(message: String) {
        errorMessage = message
        showError = true
    }

    var body: some View {
        PhotosPicker(selection: $selectedPhotosPickerImages, maxSelectionCount: 100, matching: .any(of: [.images, .not(.livePhotos)])) {
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(.systemGray4))
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
                    .aspectRatio(1, contentMode: .fit)
                if showCheckmarkAnimation {
                    CheckmarkAnimation()
                } else if isUploading {
                    VStack {
                        HStack(spacing: 0) {
                            Text("Uploading")
                            LoadingEllipsis(interval: 0.25)
                        }
                        .font(.system(size: 14.5, weight: .medium))
                        .frame(width: 85, alignment: .leading)
                        .foregroundColor(.white)
                        .padding(.leading, 10)

                        ZStack {
                            Circle()
                                .stroke(lineWidth: 2)
                                .foregroundColor(.white)
                                .opacity(0.2)

                            Circle()
                                .trim(from: 0, to: CGFloat(uploadProgress?.current ?? 0) / CGFloat(uploadProgress?.total ?? 1))
                                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .foregroundColor(.white)
                                .animation(.easeInOut(duration: 0.2), value: uploadProgress)

                            Text("\(uploadProgress?.current ?? 0) / \(uploadProgress?.total ?? 0)")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .frame(width: 60, height: 60)
                    }
                } else {
                    Image(systemName: "plus").font(.system(size: 23.5, weight: .medium))
                        .accentColor(.white.opacity(0.8))
                }
            }
        }
        .onChange(of: selectedPhotosPickerImages) { newImages in
            Task {
                handleUploadImages(imagesSelected: newImages)
            }
        }
        .disabled(isUploading)
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}
