//
//  CardFrameView.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 13.03.26.
//

import SwiftUI

struct CardFrameView: View {

    var body: some View {

        RoundedRectangle(cornerRadius: 20)
            .stroke(Color.black.opacity(0.2), lineWidth: 3)
            .frame(height: 220)
            .overlay(
                VStack {
                    HStack {
                        Text("TBC")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding()

                    Spacer()

                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.yellow)
                            .frame(width: 40, height: 30)

                        Spacer()
                    }
                    .padding()
                }
            )

    }
}
