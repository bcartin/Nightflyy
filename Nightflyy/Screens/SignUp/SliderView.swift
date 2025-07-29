//
//  SliderView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/28/24.
//

import SwiftUI

struct SliderView: View {
    public let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    @State private var currentPage: String = ""
    @State private var listOfPages: [SliderPageModel] = [SliderPageModel(image: "slider1", header: "Discover", subheader: "Events based on your vibe"),
                                                         SliderPageModel(image: "slider2", header: "Connect", subheader: "With friends, promoters and venues"),
                                                         SliderPageModel(image: "slider3", header: "Host", subheader: "Parties, Kickbacks, pre-games & more"),
                                                         SliderPageModel(image: "slider4", header: "Rate", subheader: "Bars, clubs, lounges & more")]
    
    //Infite Carousel Properties
    @State private var fakedPages: [SliderPageModel] = []
    
    var body: some View {
//        ZStack {
            GeometryReader {
                let size = $0.size
                
                TabView(selection: $currentPage) {
                    ForEach(fakedPages) { page in
                        ZStack {
                            Image(page.image)
                                .resizable()
                                .scaledToFill()
                            
                            Rectangle()
                                .fill(.linearGradient(colors: [.backgroundBlack, .backgroundBlack.opacity(0.3), .backgroundBlack], startPoint: .top, endPoint: .bottom))
                                .frame(height: 500)
                            
                            VStack {
                                Text(page.header.uppercased())
                                    .foregroundStyle(.mainPurple)
                                    .font(.custom("Bebas-Regular", size: 48))
                                
                                Text(page.subheader.uppercased())
                                    .foregroundStyle(.white)
                                    .font(.custom("Bebas-Regular", size: 17))
                            }
                            .padding(.bottom, 72)
                        }
                        .tag(page.id.uuidString)
                        .offsetX(currentPage == page.id.uuidString) { rect in
                            let minX = rect.minX
                            let pageOffset = minX - (size.width * CGFloat(fakeIndex(page)))
                            let pageProgress = pageOffset / size.width
                            if -pageProgress < 1.0 {
                                if fakedPages.indices.contains(fakedPages.count - 1) {
                                    currentPage = fakedPages[fakedPages.count - 1].id.uuidString
                                }
                            }
                            
                            if -pageProgress > CGFloat(fakedPages.count - 1) {
                                if fakedPages.indices.contains(1) {
                                    currentPage = fakedPages[1].id.uuidString
                                }
                            }
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onReceive(timer, perform: { _ in
                    if let index = fakedPages.firstIndex(where: {$0.id.uuidString == currentPage}) {
                        withAnimation {
                            currentPage = index < (fakedPages.count - 1) ? fakedPages[index + 1].id.uuidString : (fakedPages.first?.id.uuidString)!
                        }
                    }
                })
            }
            .frame(height: 500) // Change size of images
            .onAppear {
                guard fakedPages.isEmpty else {return}
                
                fakedPages.append(contentsOf: listOfPages)
                
                if var firstPage = listOfPages.first, var lastPage = listOfPages.last {
                    currentPage = firstPage.id.uuidString

                    firstPage.id = .init()
                    lastPage.id = .init()
                                        
                    fakedPages.append(firstPage)
                    fakedPages.insert(lastPage, at: 0)
                }
            }
    }
    
    func fakeIndex(_ of: SliderPageModel) -> Int {
        return fakedPages.firstIndex(of: of) ?? 0
    }
}

#Preview {
    SliderView()
}
