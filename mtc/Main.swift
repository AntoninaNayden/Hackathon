import SwiftUI

struct Choose: View {
    @State private var currentIndex = 0
    @State private var selectedType: SensorType?
    @State private var selectedTab: Tab = .profile
    
    let sensorTypes: [SensorType] = [
        .door, .airQuality, .gasLeak, .tempHumidity, .energyConsumption, .vibration, .light
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    switch selectedTab {
                    case .profile:
                        chooseContent
                    case .world:
                        City()
                    case .user:
                        ProfileView()
                    }
                    
                    Spacer()
                    
                    MainTabView(selectedTab: $selectedTab)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(.black)
                        )
                        .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
//        .fullScreenCover(item: $selectedType) { type in
//            SensorListView(sensorType: type)
//        }
    }
    
    var chooseContent: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                MetalImages()
                
                VStack {
                    Text(sensorTypes[currentIndex].description)
                                            .font(.title)
                                            .foregroundColor(.white)
                                            .bold()
                                            .padding(.top, 20)
                                            .padding(.horizontal, 16)
                    
                    Spacer()
                        .frame(height: 40)
                    
                    // Горизонтальный скролл с эффектом центрирования и анимации
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(sensorTypes.indices, id: \.self) { index in
                                GeometryReader { proxy in
                                    ZStack {
                                        VStack {
                                            Image(sensorTypes[index].imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                
                                                .frame(width: 260, height: 320)
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                            
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    currentIndex == index ? Color(red: 183/255, green: 13/255, blue: 34/255) : Color.clear,
                                                    lineWidth: 3
                                                )
                                        )
                                        .scaleEffect(currentIndex == index ? 1 : 0.9)
                                        .animation(.spring(), value: currentIndex)
                                    }
                                    .onAppear {
                                        if abs(proxy.frame(in: .global).midX - geometry.size.width / 2) < 50 {
                                            withAnimation {
                                                currentIndex = index
                                            }
                                        }
                                    }
                                    .onChange(of: proxy.frame(in: .global).midX) { value in
                                        if abs(value - geometry.size.width / 2) < 50 {
                                            withAnimation {
                                                currentIndex = index
                                            }
                                        }
                                    }
                                    .onTapGesture {
                                        currentIndex = index
                                    }
                                }
                                .frame(width: 320, height: 420)
                            }
                        }
                        .padding(.horizontal, geometry.size.width / 3.7) // Центрирование элементов
                    }
                    
                    Spacer()
                        .frame(height: 40)
                    
                    Button(action: {
                        selectedType = sensorTypes[currentIndex]
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Подробнее")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .frame(width: 270)
                        .background(Color(red: 183/255, green: 13/255, blue: 34/255))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 180)
                    }
                }
            }
        }
    }
}

// MARK: - Экран со списком сенсоров выбранного типа
struct SensorListView: View {
    let sensorType: SensorType
    
    @State private var sensors: [Sensor] = [
        Sensor(id: UUID(), name: "Датчик двери 1", description: "Контроль двери", serialNumber: "SN-001", sensorType: .door,
               doorSensorConfiguration: DoorSensorConfiguration(sensitivity: 5),
               airQualitySensorConfiguration: nil,
               gasLeakSensorConfiguration: nil,
               tempHumiditySensorConfiguration: nil,
               energyConsumptionSensorConfiguration: nil,
               vibrationSensorConfiguration: nil,
               lightSensorConfiguration: nil),
        
        Sensor(id: UUID(), name: "Датчик двери 2", description: "Контроль двери", serialNumber: "SN-002", sensorType: .door,
               doorSensorConfiguration: DoorSensorConfiguration(sensitivity: 7),
               airQualitySensorConfiguration: nil,
               gasLeakSensorConfiguration: nil,
               tempHumiditySensorConfiguration: nil,
               energyConsumptionSensorConfiguration: nil,
               vibrationSensorConfiguration: nil,
               lightSensorConfiguration: nil)
    ]
    
    var filteredSensors: [Sensor] {
        sensors.filter { $0.sensorType == sensorType }
    }
    
    var body: some View {
        NavigationView {
            List(filteredSensors, id: \.id) { sensor in
                HStack(spacing: 12) {
                    Image(sensor.sensorType.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(sensor.name)
                            .font(.headline)
                        
                        Text("Тип: \(sensor.sensorType.description)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("Серийный номер: \(sensor.serialNumber)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 8)
            }
            .navigationTitle(sensorType.description)
        }
    }
}

// MARK: - Расширение для получения имени изображения
private extension SensorType {
    var imageName: String {
        switch self {
        case .door: return "door"
        case .airQuality: return "airQuality"
        case .gasLeak: return "gasLeak"
        case .tempHumidity: return "tempHumidity"
        case .energyConsumption: return "energyConsumption"
        case .vibration: return "vibration"
        case .light: return "light"
        }
    }
}

struct Choose_Previews: PreviewProvider {
    static var previews: some View {
        Choose()
    }
}

        //
        ////                ZStack{
        //                RoundedRectangle(cornerRadius: 35)
        //                    .frame(width: 370, height: 400)
        //                    .foregroundColor(.white)
        //                    VStack{
        //                        Image("heart")
        //                            .resizable()
        //                            .frame(width: 350, height: 350)
        //                        Text("Узнать больше о Вашем здоровье:")
        //                            .foregroundColor(.black)
        //                            .font(.system(size: 30))
        //                            .bold()
        //                            .padding(.top, -30)
        //                    }
        //                }
        


