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
        VStack {
            if let image = iconVM.selectedImage {
                
            } else {
                // TODO: Add Button
                ZStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(environment.colorScheme == .dark ? Color.black : Color.white)
                            .padding(15)
                            .background(.primary, in: RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
        .frame(width: 400, height: 400)
        .buttonStyle(.plain)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
