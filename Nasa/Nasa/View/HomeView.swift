//
//  HomeView.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import SwiftUI
import CustomAlert

struct HomeView: View {
    
    @EnvironmentObject var homeViewModel : HomeViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedDate = Date()
    @State private var showAlert = false
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FilterHistory.id, ascending: true)],
        animation: .default)
    
    private var history: FetchedResults<FilterHistory>
    
    @State var showingRoverPickerSheet = false
    @State var showingCameraPickerSheet = false
    @State var showingCalendarPopUp = false
    @State var selectedRowerName = "All"
    @State var selectedCameraName = "FHAZ"
    
    // MARK: Body -
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

// MARK: Header View -
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
                Button (action: {
                    showingCalendarPopUp.toggle()
                }, label: {
                    Image("Calendar")
                        .resizable()
                        .frame(width: 44, height: 44)
                })
                .customAlert("", isPresented: $showingCalendarPopUp) {
                    calendarPicker
                }
                .environment(\.customAlertConfiguration, .create { configuration in
                    configuration.background = .blurEffect(.systemChromeMaterialDark)
                    configuration.padding = EdgeInsets()
                    configuration.alert = .create { alert in
                        alert.background = .color(.backgroundOne)
                        alert.cornerRadius = 30
                        alert.padding = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                        alert.minWidth = 300
                        alert.alignment = .leading
                        alert.spacing = 10
                    }
                }
            )}
       
            HStack {
                HStack {
                    HStack {
                        Image("Rover")
                        Button(action: {
                            showingRoverPickerSheet.toggle()
                        }, label: {
                            Text(selectedRowerName)
                                .font(Font.custom("SFPro-Bold", size: 17))
                                .frame(height: 22)
                        })
                        .sheet(isPresented: $showingRoverPickerSheet, content: {
                            roverPicker
                                .presentationDetents([.height(306)])
                        })
                        Spacer()
                    }
                    .foregroundColor(Color.layerOne)
                    .frame(width: 140, height: 38)
                    .background(Color.backgroundOne)
                    .accentColor(Color.layerOne)
                    .cornerRadius(4.0)
                    
                    HStack {
                        Image("Camera")
                        Button(action: {
                            showingCameraPickerSheet.toggle()
                        }, label: {
                            Text(selectedCameraName)
                                .font(Font.custom("SFPro-Bold", size: 17))
                                .frame(height: 22)
                        })
                        .sheet(isPresented: $showingCameraPickerSheet, content: {
                            cameraPicker
                                .presentationDetents([.height(306)])
                        })
                        Spacer()
                    }
                    .foregroundColor(Color.layerOne)
                    .frame(width: 140, height: 38)
                    .background(Color.backgroundOne)
                    .accentColor(Color.layerOne)
                    .cornerRadius(4.0)
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

// MARK: Floating Button -
extension HomeView {
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
}

// MARK: Pickers -

extension HomeView {
    
    // Rover Picker
    var roverPicker: some View {
        VStack {
            HStack {
                Button {
                    showingRoverPickerSheet.toggle()
                } label: {
                    Image("Close")
                }
                Spacer()
                Text(selectedRowerName)
                    .font(Font.custom("SFPro-Bold", size: 22))
                Spacer()
                Button {
                    callPhotosApi()
                    selectedRowerName = homeViewModel.rover
                    showingRoverPickerSheet.toggle()
                } label: {
                    Image("Tick")
                }
            }.padding([.leading, .trailing, .top], 20)
            
            Spacer()
            
            Picker(selection: $homeViewModel.selectedRover, label: FilterButton(iconName: "Rover", text: homeViewModel.rover)) {
                ForEach(Rover.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .onChange(of: homeViewModel.selectedRover.rawValue) { _ in
                homeViewModel.rover = homeViewModel.selectedRover.rawValue
            }
            .pickerStyle(.wheel)
            Spacer()
        }
    }
    
    // Camera Picker
    var cameraPicker: some View {
        VStack {
            HStack {
                Button {
                    showingCameraPickerSheet.toggle()
                } label: {
                    Image("Close")
                }
                Spacer()
                Text("Camera")
                    .font(Font.custom("SFPro-Bold", size: 22))
                
                Spacer()
                Button {
                    callPhotosApi()
                    selectedCameraName = homeViewModel.camera
                    showingCameraPickerSheet.toggle()
                    
                } label: {
                    Image("Tick")
                }
            }.padding([.leading, .trailing, .top], 20)
            
            Spacer()
            
            Picker(selection: $homeViewModel.selectedCamera, label: FilterButton(iconName: "Camera", text: homeViewModel.selectedCamera.rawValue)) {
                ForEach(homeViewModel.availableCameras, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .onChange(of: homeViewModel.selectedCamera.rawValue) { _ in
                homeViewModel.camera = homeViewModel.selectedCamera.rawValue
            }
            .pickerStyle(.wheel)
            Spacer()
        }
    }
    
    // Calendar Picker
    var calendarPicker: some View {
        VStack {
            HStack {
                Button {
                    showingCalendarPopUp.toggle()
                } label: {
                    Image("Close")
                }
                Spacer()
                Text("Date")
                    .font(Font.custom("SFPro-Bold", size: 22))
                
                Spacer()
                Button {
                    callPhotosApi()
                    showingCalendarPopUp.toggle()
                    
                } label: {
                    Image("Tick")
                }
            }.padding([.leading, .trailing, .top], 20)
            
            Spacer()
            
            DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .accentColor(Color.layerOne)
                .padding()
                .onChange(of: selectedDate) { _ in
                    homeViewModel.seletedDate = selectedDate.DateToString()
                }
            Spacer()
        }
    }
}
