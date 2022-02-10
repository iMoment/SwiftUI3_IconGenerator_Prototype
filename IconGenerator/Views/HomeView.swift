//
//  HomeView.swift
//  IconGenerator
//
//  Created by Stanley Pan on 2022/02/10.
//

import SwiftUI

struct HomeView: View {
    @StateObject var iconVM: IconVM = IconVM()
    @Environment(\.self) var environment
    
    var body: some View {
        VStack(spacing: 15) {
            if let image = iconVM.selectedImage {
                // MARK: Displaying Image with Action
                Group {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 250)
                        .clipped()
                    
                    // MARK: Generate Button
                    Button {
                        iconVM.generateIconSet()
                    } label: {
                        Text("Generate Icon Set")
                            .foregroundColor(environment.colorScheme == .dark ? Color.black : Color.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 18)
                            .background(.primary, in: RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.top, 10)
                }
            } else {
                // TODO: Add Button
                ZStack {
                    Button {
                        iconVM.selectImage()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(environment.colorScheme == .dark ? Color.black : Color.white)
                            .padding(15)
                            .background(.primary, in: RoundedRectangle(cornerRadius: 10))
                    }
                    Text("1024 X 1024 is recommended!")
                        .font(.caption2)
                        .foregroundColor(Color.gray)
                        .padding(.bottom, 10)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
        }
        .frame(width: 400, height: 400)
        .buttonStyle(.plain)
        // MARK: Alert View
        .alert(iconVM.alertMessage, isPresented: $iconVM.showAlert) {
            
        }
        // MARK: Loading View
        .overlay {
            ZStack {
                if iconVM.isGenerating {
                    Color.black
                        .opacity(0.25)
                    
                    ProgressView()
                        .padding()
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                    // Always Light Mode
                        .environment(\.colorScheme, .light)
                }
            }
        }
        .animation(.easeInOut, value: iconVM.isGenerating)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
