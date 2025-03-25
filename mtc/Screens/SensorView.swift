import Alamofire
import SwiftUI

// MARK: - Sensor Types

enum SensorType: Int, Decodable, CaseIterable {
    case door = 0
    case airQuality = 1
    case gasLeak = 2
    case tempHumidity = 3
    case energyConsumption = 4
    case vibration = 5
    case light = 6
    
    var description: String {
        switch self {
        case .door: return "Дверной сенсор"
        case .airQuality: return "Качество воздуха"
        case .gasLeak: return "Утечка газа"
        case .tempHumidity: return "Температура/Влажность"
        case .energyConsumption: return "Потребление энергии"
        case .vibration: return "Вибрация"
        case .light: return "Освещение"
        }
    }
}

// MARK: - Sensor Configurations

struct DoorSensorConfiguration: Decodable {
    let sensitivity: Int
}

struct AirQualitySensorConfiguration: Decodable {
    let calibrationFactor: Double
    let warningThreshold: Double
}

struct GasLeakSensorConfiguration: Decodable {
    let criticalThreshold: Double
    let gasType: String
}

struct TempHumiditySensorConfiguration: Decodable {
    let temperatureOffset: Double
    let humidityOffset: Double
    let tempMin: Double
    let tempMax: Double
    let humidityMin: Double
    let humidityMax: Double
}

struct EnergyConsumptionSensorConfiguration: Decodable {
    let samplingRateSeconds: Int
    let consumptionThreshold: Double
}

struct VibrationSensorConfiguration: Decodable {
    let sensitivity: Double
    let threshold: Double
}

struct LightSensorConfiguration: Decodable {
    let minLightLevel: Double
    let maxLightLevel: Double
}

// MARK: - Sensor Model

struct Sensor: Decodable {
    let id: UUID
    let name: String
    let description: String?
    let serialNumber: String
    let sensorType: SensorType
    let doorSensorConfiguration: DoorSensorConfiguration?
    let airQualitySensorConfiguration: AirQualitySensorConfiguration?
    let gasLeakSensorConfiguration: GasLeakSensorConfiguration?
    let tempHumiditySensorConfiguration: TempHumiditySensorConfiguration?
    let energyConsumptionSensorConfiguration: EnergyConsumptionSensorConfiguration?
    let vibrationSensorConfiguration: VibrationSensorConfiguration?
    let lightSensorConfiguration: LightSensorConfiguration?
}

// MARK: - Sensor Service

class SensorService {
    static let shared = SensorService()
    private let baseURL = "https://www.smikerls.site"
    
    func fetchSensors(completion: @escaping (Result<[Sensor], Error>) -> Void) {
        guard let accessToken = KeychainService.shared.getToken(type: .access) else {
            completion(.failure(AuthError.missingToken))
            return
        }
        
        let url = "\(baseURL)/sensors"
        let headers: HTTPHeaders = [.authorization(bearerToken: accessToken)]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [Sensor].self) { [weak self] response in
                switch response.result {
                case .success(let sensors):
                    print("Получены данные сенсоров: \(sensors)")
                    completion(.success(sensors))
                case .failure(let error):
                    print("Ошибка запроса: \(error.localizedDescription)")
                    if let responseData = response.data {
                        print("Тело ответа: \(responseData.prettyPrintedJSONString ?? "нет данных")")
                    }
                    if response.response?.statusCode == 401 {
                        self?.refreshAndRetryFetchSensors(completion: completion)
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }

    func createSensor(sensorType: SensorType, sensorConfig: Any, completion: @escaping (Result<Sensor, Error>) -> Void) {
        guard let accessToken = KeychainService.shared.getToken(type: .access) else {
            completion(.failure(AuthError.missingToken))
            return
        }

        let url = "\(baseURL)/sensors"
        let headers: HTTPHeaders = [.authorization(bearerToken: accessToken), .contentType("application/json")]

        var parameters: [String: Any] = [
            "name": "Sensor Name",
            "description": "Sensor Description",
            "serialNumber": "sensor_serial_number",
            "sensorType": sensorType.rawValue
        ]

        switch sensorType {
        case .door:
            parameters["doorSensorConfiguration"] = sensorConfig
        case .airQuality:
            parameters["airQualitySensorConfiguration"] = sensorConfig
        case .gasLeak:
            parameters["gasLeakSensorConfiguration"] = sensorConfig
        case .tempHumidity:
            parameters["tempHumiditySensorConfiguration"] = sensorConfig
        case .energyConsumption:
            parameters["energyConsumptionSensorConfiguration"] = sensorConfig
        case .vibration:
            parameters["vibrationSensorConfiguration"] = sensorConfig
        case .light:
            parameters["lightSensorConfiguration"] = sensorConfig
        }

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: Sensor.self) { response in
                switch response.result {
                case .success(let sensor):
                    print("Создан новый сенсор: \(sensor)")
                    completion(.success(sensor))
                case .failure(let error):
                    print("Ошибка запроса: \(error.localizedDescription)")
                    if let responseData = response.data {
                        print("Тело ответа: \(responseData.prettyPrintedJSONString ?? "нет данных")")
                    }
                    completion(.failure(error))
                }
            }
    }

    private func refreshAndRetryFetchSensors(completion: @escaping (Result<[Sensor], Error>) -> Void) {
        AuthService.shared.refreshToken { result in
            switch result {
            case .success:
                self.fetchSensors(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Data Extension for Pretty Printing JSON
struct SensorsView: View {
    @State private var sensors: [Sensor] = [
        // Дверные сенсоры
        Sensor(id: UUID(), name: "Дверной сенсор 1", description: "Контроль двери", serialNumber: "SN-001", sensorType: .door,
               doorSensorConfiguration: DoorSensorConfiguration(sensitivity: 5),
               airQualitySensorConfiguration: nil,
               gasLeakSensorConfiguration: nil,
               tempHumiditySensorConfiguration: nil,
               energyConsumptionSensorConfiguration: nil,
               vibrationSensorConfiguration: nil,
               lightSensorConfiguration: nil),
        
        Sensor(id: UUID(), name: "Дверной сенсор 2", description: "Контроль двери", serialNumber: "SN-002", sensorType: .door,
               doorSensorConfiguration: DoorSensorConfiguration(sensitivity: 7),
               airQualitySensorConfiguration: nil,
               gasLeakSensorConfiguration: nil,
               tempHumiditySensorConfiguration: nil,
               energyConsumptionSensorConfiguration: nil,
               vibrationSensorConfiguration: nil,
               lightSensorConfiguration: nil),
        
        Sensor(id: UUID(), name: "Дверной сенсор 3", description: "Контроль двери", serialNumber: "SN-003", sensorType: .door,
               doorSensorConfiguration: DoorSensorConfiguration(sensitivity: 3),
               airQualitySensorConfiguration: nil,
               gasLeakSensorConfiguration: nil,
               tempHumiditySensorConfiguration: nil,
               energyConsumptionSensorConfiguration: nil,
               vibrationSensorConfiguration: nil,
               lightSensorConfiguration: nil),
        
        // Датчики качества воздуха
        Sensor(id: UUID(), name: "Датчик качества воздуха 1", description: "Контроль загрязнения воздуха", serialNumber: "SN-004", sensorType: .airQuality,
               doorSensorConfiguration: nil,
               airQualitySensorConfiguration: AirQualitySensorConfiguration(calibrationFactor: 1.2, warningThreshold: 80.0),
               gasLeakSensorConfiguration: nil,
               tempHumiditySensorConfiguration: nil,
               energyConsumptionSensorConfiguration: nil,
               vibrationSensorConfiguration: nil,
               lightSensorConfiguration: nil),
        
        Sensor(id: UUID(), name: "Датчик качества воздуха 2", description: "Контроль загрязнения воздуха", serialNumber: "SN-005", sensorType: .airQuality,
               doorSensorConfiguration: nil,
               airQualitySensorConfiguration: AirQualitySensorConfiguration(calibrationFactor: 1.3, warningThreshold: 85.0),
               gasLeakSensorConfiguration: nil,
               tempHumiditySensorConfiguration: nil,
               energyConsumptionSensorConfiguration: nil,
               vibrationSensorConfiguration: nil,
               lightSensorConfiguration: nil),
        
        Sensor(id: UUID(), name: "Датчик качества воздуха 3", description: "Контроль загрязнения воздуха", serialNumber: "SN-006", sensorType: .airQuality,
               doorSensorConfiguration: nil,
               airQualitySensorConfiguration: AirQualitySensorConfiguration(calibrationFactor: 1.1, warningThreshold: 75.0),
               gasLeakSensorConfiguration: nil,
               tempHumiditySensorConfiguration: nil,
               energyConsumptionSensorConfiguration: nil,
               vibrationSensorConfiguration: nil,
               lightSensorConfiguration: nil),
        
        // Датчики утечки газа
        Sensor(id: UUID(), name: "Датчик утечки газа 1", description: "Оповещение о критической утечке газа", serialNumber: "SN-007", sensorType: .gasLeak,
               doorSensorConfiguration: nil,
               airQualitySensorConfiguration: nil,
               gasLeakSensorConfiguration: GasLeakSensorConfiguration(criticalThreshold: 50.0, gasType: "Метан"),
               tempHumiditySensorConfiguration: nil,
               energyConsumptionSensorConfiguration: nil,
               vibrationSensorConfiguration: nil,
               lightSensorConfiguration: nil),
        
        Sensor(id: UUID(), name: "Датчик утечки газа 2", description: "Оповещение о критической утечке газа", serialNumber: "SN-008", sensorType: .gasLeak,
               doorSensorConfiguration: nil,
               airQualitySensorConfiguration: nil,
               gasLeakSensorConfiguration: GasLeakSensorConfiguration(criticalThreshold: 45.0, gasType: "Пропан"),
               tempHumiditySensorConfiguration: nil,
               energyConsumptionSensorConfiguration: nil,
               vibrationSensorConfiguration: nil,
               lightSensorConfiguration: nil),
        
        Sensor(id: UUID(), name: "Датчик утечки газа 3", description: "Оповещение о критической утечке газа", serialNumber: "SN-009", sensorType: .gasLeak,
               doorSensorConfiguration: nil,
               airQualitySensorConfiguration: nil,
               gasLeakSensorConfiguration: GasLeakSensorConfiguration(criticalThreshold: 60.0, gasType: "Бутан"),
               tempHumiditySensorConfiguration: nil,
               energyConsumptionSensorConfiguration: nil,
               vibrationSensorConfiguration: nil,
               lightSensorConfiguration: nil),
        
        // Датчики температуры и влажности
        Sensor(id: UUID(), name: "Датчик температуры и влажности 1", description: "Контроль температуры и влажности", serialNumber: "SN-010", sensorType: .tempHumidity,
               doorSensorConfiguration: nil,
               airQualitySensorConfiguration: nil,
               gasLeakSensorConfiguration: nil,
               tempHumiditySensorConfiguration: TempHumiditySensorConfiguration(temperatureOffset: 0.5, humidityOffset: 1.0, tempMin: 15.0, tempMax: 30.0, humidityMin: 40.0, humidityMax: 60.0),
               energyConsumptionSensorConfiguration: nil,
               vibrationSensorConfiguration: nil,
               lightSensorConfiguration: nil),
        
        Sensor(id: UUID(), name: "Датчик температуры и влажности 2", description: "Контроль температуры и влажности", serialNumber: "SN-011", sensorType: .tempHumidity,
               doorSensorConfiguration: nil,
               airQualitySensorConfiguration: nil,
               gasLeakSensorConfiguration: nil,
               tempHumiditySensorConfiguration: TempHumiditySensorConfiguration(temperatureOffset: 0.7, humidityOffset: 1.5, tempMin: 18.0, tempMax: 28.0, humidityMin: 35.0, humidityMax: 65.0),
               energyConsumptionSensorConfiguration: nil,
               vibrationSensorConfiguration: nil,
               lightSensorConfiguration: nil)
    ]
    
    @State private var selectedSensorType: SensorType? = nil
    
    var filteredSensors: [Sensor] {
        if let selectedType = selectedSensorType {
            return sensors.filter { $0.sensorType == selectedType }
        }
        return sensors
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Выберите тип сенсора", selection: $selectedSensorType) {
                    Text("Все").tag(SensorType?.none)
                    ForEach(SensorType.allCases, id: \..self) { type in
                        Text(type.description).tag(type as SensorType?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                List(filteredSensors, id: \..id) { sensor in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Серийный номер: \(sensor.serialNumber)")
                            .font(.headline)
                        
                        Text("Тип: \(sensor.sensorType.description)")
                            .font(.subheadline)
                        
                        Text("Описание: \(sensor.description ?? "Нет описания")")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Сенсоры")
        }
    }
}

import Foundation

extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}

// MARK: - SwiftUI View

//struct SensorsView: View {
//    @State private var sensors: [Sensor] = []
//    @State private var errorMessage: String?
//    @State private var isLoading: Bool = false
//
//    var body: some View {
//        NavigationView {
//            List(sensors, id: \.serialNumber) { sensor in
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Серийный номер: \(sensor.serialNumber)")
//                        .font(.headline)
//
//                    Text("Тип: \(sensor.sensorType.description)")
//                        .font(.subheadline)
//
//                    Group {
//                        switch sensor.sensorType {
//                        case .door:
//                            Text("Чувствительность: \(sensor.doorSensorConfiguration?.sensitivity ?? 0)")
//                        case .airQuality:
//                            Text("Калибровка: \(sensor.airQualitySensorConfiguration?.calibrationFactor ?? 0, specifier: "%.2f")")
//                            Text("Порог: \(sensor.airQualitySensorConfiguration?.warningThreshold ?? 0, specifier: "%.2f")")
//                        case .gasLeak:
//                            Text("Критический порог: \(sensor.gasLeakSensorConfiguration?.criticalThreshold ?? 0, specifier: "%.2f")")
//                            Text("Тип газа: \(sensor.gasLeakSensorConfiguration?.gasType ?? "N/A")")
//                        case .tempHumidity:
//                            Text("Температура: \(sensor.tempHumiditySensorConfiguration?.tempMin ?? 0)...\(sensor.tempHumiditySensorConfiguration?.tempMax ?? 0)")
//                            Text("Влажность: \(sensor.tempHumiditySensorConfiguration?.humidityMin ?? 0)...\(sensor.tempHumiditySensorConfiguration?.humidityMax ?? 0)")
//                        case .energyConsumption:
//                            Text("Интервал измерений: \(sensor.energyConsumptionSensorConfiguration?.samplingRateSeconds ?? 0) сек")
//                            Text("Порог потребления: \(sensor.energyConsumptionSensorConfiguration?.consumptionThreshold ?? 0, specifier: "%.2f")")
//                        case .vibration:
//                            Text("Чувствительность: \(sensor.vibrationSensorConfiguration?.sensitivity ?? 0)")
//                            Text("Порог: \(sensor.vibrationSensorConfiguration?.threshold ?? 0)")
//                        case .light:
//                            Text("Уровень освещения: \(sensor.lightSensorConfiguration?.minLightLevel ?? 0)...\(sensor.lightSensorConfiguration?.maxLightLevel ?? 0)")
//                        }
//                    }
//                    .font(.caption)
//                }
//                .padding(.vertical, 8)
//            }
//            .navigationTitle("Сенсоры")
//            .onAppear(perform: loadSensors)
//            .overlay(
//                Group {
//                    if isLoading {
//                        ProgressView()
//                    }
//                }
//            )
//            .alert("Ошибка", isPresented: .constant(errorMessage != nil)) {
//                Button("OK", role: .cancel) { }
//            } message: {
//                Text(errorMessage ?? "")
//            }
//        }
//    }
//
//    private func loadSensors() {
//        isLoading = true
//        SensorService.shared.fetchSensors { result in
//            switch result {
//            case .success(let fetchedSensors):
//                self.sensors = fetchedSensors
//                self.isLoading = false
//            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//                self.isLoading = false
//            }
//        }
//    }
//}
