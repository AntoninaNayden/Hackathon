import SwiftUI

struct City: View {
    // ✅ Пример данных о датчиках (в реальном проекте можно брать из API)
    let temperature: Double = 37
    let humidity: Double = 95
    let airQuality: Double = 45
    let pollution: Double = 55
    let noiseLevel: Double = 72
    let pressure: Double = 1013
    
    var body: some View {
        ZStack {
            MetalImages()
            
            VStack(spacing: 20) {
                // ✅ Заголовок
                Text("Умный город")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.top, 40)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // ✅ Основные датчики
                        SensorCard(
                            title: "Атмосферное давление",
                            value: "\(pressure) гПа",
                            icon: "gauge.medium",
                            backgroundColor: Color.blue
                        )
                        
                        SensorCard(
                            title: "Чистота воздуха",
                            value: "\(airQuality)%",
                            icon: "leaf.fill",
                            backgroundColor: Color.green
                        )
                        
                        SensorCard(
                            title: "Температура",
                            value: "\(temperature)°C",
                            icon: "thermometer",
                            backgroundColor: Color.red
                        )
                        
                        SensorCard(
                            title: "Влажность",
                            value: "\(humidity)%",
                            icon: "humidity",
                            backgroundColor: Color.cyan
                        )
                        
                        SensorCard(
                            title: "Загрязнение воздуха",
                            value: "PM2.5: \(pollution) мкг/м³",
                            icon: "aqi.high",
                            backgroundColor: Color.orange
                        )
                        
                        SensorCard(
                            title: "Уровень шума",
                            value: "\(noiseLevel) дБ",
                            icon: "ear.fill",
                            backgroundColor: Color.purple
                        )
                        
                        // ✅ Критические состояния
                        if temperature > 35 {
                            CriticalStateCard(
                                title: "Температура",
                                message: "Температура выше 35°C — возможно тепловое воздействие",
                                icon: "thermometer"
                            )
                        }
                        
                        if humidity < 30 || humidity > 90 {
                            CriticalStateCard(
                                title: "Влажность",
                                message: "Влажность вне нормы (норма 30-90%)",
                                icon: "humidity"
                            )
                        }
                        
                        if airQuality < 50 {
                            CriticalStateCard(
                                title: "Чистота воздуха",
                                message: "Чистота воздуха ниже 50% — плохое качество воздуха",
                                icon: "leaf.fill"
                            )
                        }
                        
                        if pollution > 50 {
                            CriticalStateCard(
                                title: "Загрязнение воздуха",
                                message: "PM2.5 превышает безопасный уровень",
                                icon: "aqi.high"
                            )
                        }
                        
                        if noiseLevel > 70 {
                            CriticalStateCard(
                                title: "Уровень шума",
                                message: "Шум выше нормы (норма до 70 дБ)",
                                icon: "ear.fill"
                            )
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

// ✅ Обычная карточка датчика
struct SensorCard: View {
    var title: String
    var value: String
    var icon: String
    var backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        //.background(Color.black.opacity(0.8))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

// ✅ Карточка критического состояния
struct CriticalStateCard: View {
    var title: String
    var message: String
    var icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(red: 183/255, green: 13/255, blue: 34/255))
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal, 0)
    }
}

#Preview {
    City()
}

