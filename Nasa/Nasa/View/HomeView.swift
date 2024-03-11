//
//  HomeView.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var homeViewModel : HomeViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedDate = Date()
    @State private var showAlert = false
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FilterHistory.id, ascending: true)],
        animation: .default)
    
    private var history: FetchedResults<FilterHistory>

    var body: some View {
        NavigationView {
            ZStack(alignment:.bottomTrailing) {
                ZStack {
                    ZStack {
                        Color.backgroundOne.ignoresSafeArea()
                        VStack {
                            headerView
                            if homeViewModel.apiResponse  {
                                Text("No Record Found")
                            }else {
                                List {
                                    ForEach(homeViewModel.photos, id: \.id) { photo in
                                        ZStack {
                                            HomeListItem(roverName: "\(photo.rover.name)",
                                                         cameraName: "\(photo.camera.fullName)",
                                                         date: "\(photo.earthDate.DateToString())",
                                                         imageURL: "\(photo.imgSrc)")
                                            NavigationLink(destination: FullImageView(imageURL: "\(photo.imgSrc)")) {
                                            }
                                        }
                                    }
                                    .listRowBackground(Color.backgroundOne)
                                    .listRowSeparator(.hidden)
                                }
                                .listStyle(.plain)
                                .background(Color.backgroundOne)
                                
                            }
                            Spacer()
                        }
                    }
                    .navigationBarHidden(true)
                    if homeViewModel.apiCalled {
                        ProgressView()
                    }
                }
                
                floatyBtn
                    .offset(x: -10, y: -10)
            }
            .onAppear(perform: {
                if homeViewModel.camera.isEmpty {
                    homeViewModel.camera = homeViewModel.selectedCamera.rawValue
                    homeViewModel.rover = homeViewModel.selectedRover.rawValue
                    homeViewModel.seletedDate  = Date().DateToString()
                    callPhotosApi()
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name.updateView)) { object in
                if object.object != nil {
                    callPhotosApi()
                }
               }
        }
    }
}

extension HomeView {
    var headerView: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("MARS.CAMERA")
                        .font(Font.custom("SFPro-Bold", size: 34))
                        .frame(height: 44)
                        .multilineTextAlignment(.leading)
                    Text(selectedDate.DateToString())
                        .font(Font.custom("SFPro-Bold", size: 17))
                        .frame(height: 22)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                if !homeViewModel.isShowingDatePicker {
                    Button(action: {
                        homeViewModel.isShowingDatePicker.toggle()
                    }, label: {
                        Image("Calendar")
                            .resizable()
                            .frame(width: 44, height: 44)
                    })
                }
                if homeViewModel.isShowingDatePicker {
                               DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                                   .datePickerStyle(CompactDatePickerStyle())
                                   .labelsHidden()
                                   .accentColor(Color.layerOne)
                                   .padding()
                                   .onChange(of: selectedDate) { _ in
                                       print("changed")
                                       homeViewModel.seletedDate = selectedDate.DateToString()
                                       homeViewModel.photos = []
                                       callPhotosApi()
                                   }
                }
            }
            HStack {
                HStack {
                    HStack {
                        Image("Rover")
                        Picker(selection: $homeViewModel.selectedRover, label: FilterButton(iconName: "Rover", text: homeViewModel.rover)) {
                            ForEach(Rover.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                    }
                    .foregroundColor(Color.layerOne)
                    .frame(width: 140, height: 38)
                    .background(Color.backgroundOne)
                    .accentColor(Color.layerOne)
                    .cornerRadius(4.0)

                    HStack {
                        Image("Camera")
                        Picker(selection: $homeViewModel.selectedCamera, label: FilterButton(iconName: "Camera", text: homeViewModel.selectedCamera.rawValue)) {
                            ForEach(homeViewModel.availableCameras, id: \.self) {
                                Text($0.rawValue)
                                    .font(Font.custom("SFPro-Bold", size: 17))
                                    .frame(height: 22)
                                
                            }
                        }
                  
                    }
                    .foregroundColor(.backgroundOne)
                    .frame(width: 140, height: 38)
                    .background(
                        RoundedRectangle(cornerRadius: 4.0)
                            .fill(Color.backgroundOne)
                    )
                    .foregroundColor(Color.backgroundOne)
                    .accentColor(Color.layerOne)
                    .onChange(of: homeViewModel.selectedCamera.rawValue) { _ in
                                                homeViewModel.camera = homeViewModel.selectedCamera.rawValue
                                                homeViewModel.rover = homeViewModel.selectedRover.rawValue
                                                callPhotosApi()
                   }
                }
                Spacer()
                Button {
                    if !homeViewModel.selectedCamera.rawValue.isEmpty {
                        showAlert = true
                    }
                } label: {
                    SaveButton()
                }
            }
        }
        .padding([.leading, .trailing, .bottom], 16)
        .background(Color.accentOne)
        .onAppear(perform: {
            callPhotosApi()
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Save Filters"), message: Text("The current filters and the date you have chosen can be saved to the filter history."), primaryButton: .default(Text("Save"), action: {
                addItem()
            }), secondaryButton: .default(Text("Cancel"), action: {
                showAlert = false
            }))
        }
  
    }
    
    func callPhotosApi()  {
        
        let param = [
            "sol":"1000",
            "camera":homeViewModel.camera,
            "earth_date":homeViewModel.seletedDate,
        ]
        print(param)
        homeViewModel.getPhotosList(type:Rover(rawValue: homeViewModel.rover) ?? .curiosity , param: param)
    }
    
    var floatyBtn: some View {
        NavigationLink {
            HistoryView()
                .navigationBarBackButtonHidden()
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(Color.accentOne)
                    .frame(width: 70,height: 70)
                
                Image("History")
                    .resizable()
                    .frame(width: 35,height: 35)
            }
        }
    }
    
    private func addItem() {
        let history = FilterHistory(context: viewContext)
        history.id = UUID()
        history.camera = homeViewModel.selectedCamera.rawValue
        history.rover = homeViewModel.selectedRover.rawValue
        history.date = selectedDate.DateToString()
        do {
            try viewContext.save()
        } catch {
        
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
}
