//
//  Detector.swift
//  mtc
//
//  Created by Antonina on 19.03.25.
//

import SwiftUI
//
//
//struct Detector: Codable, Identifiable {
//    let id = UUID()
//    let serialNumber: String
//    let sensorType: Int
//    let doorSensorConfiguration: DoorSensorConfiguration?
//    let airQualitySensorConfiguration: AirQualitySensorConfiguration?
//    let gasLeakSensorConfiguration: GasLeakSensorConfiguration?
//    let tempHumiditySensorConfiguration: TempHumiditySensorConfiguration?
//    let energyConsumptionSensorConfiguration: EnergyConsumptionSensorConfiguration?
//}
//
//// Вложенные модели:
//struct DoorSensorConfiguration: Codable {
//    let pollingIntervalSeconds: Int
//    let sensitivity: Int
//}
//
//struct AirQualitySensorConfiguration: Codable {
//    let calibrationFactor: Double
//    let warningThreshold: Double
//}
//
//struct GasLeakSensorConfiguration: Codable {
//    let criticalThreshold: Double
//    let gasType: String
//}
//
//struct TempHumiditySensorConfiguration: Codable {
//    let temperatureOffset: Double
//    let humidityOffset: Double
//    let tempMin: Double
//    let tempMax: Double
//    let humidityMin: Double
//    let humidityMax: Double
//}
//
//struct EnergyConsumptionSensorConfiguration: Codable {
//    let samplingRateSeconds: Int
//    let consumptionThreshold: Double
//}
////class DetectorService {
//    private let baseURL = "https://smikerls.site/api"
//    
//    // ✅ Получение данных через GET
//    func fetchDetectors(completion: @escaping (Result<[Detector], Error>) -> Void) {
//        guard let url = URL(string: "\(baseURL)/sensors") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
//                return
//            }
//            
//            do {
//                let detectors = try JSONDecoder().decode([Detector].self, from: data)
//                completion(.success(detectors))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//    
//    // ✅ Изменение данных через POST
//    func updateDetector(_ detector: Detector, completion: @escaping (Result<Detector, Error>) -> Void) {
//        guard let url = URL(string: "\(baseURL)/sensors") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        do {
//            let jsonData = try JSONEncoder().encode(detector)
//            request.httpBody = jsonData
//        } catch {
//            completion(.failure(error))
//            return
//        }
//        
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No response", code: -1, userInfo: nil)))
//                return
//            }
//            
//            do {
//                let updatedDetector = try JSONDecoder().decode(Detector.self, from: data)
//                completion(.success(updatedDetector))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}
//struct DetectorCard: View {
//    let detector: Detector
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("Serial Number: \(detector.serialNumber)")
//                .font(.headline)
//                .foregroundColor(.black)
//            
//            Text("Sensor Type: \(detector.sensorType)")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            
//            if let config = detector.airQualitySensorConfiguration {
//                Text("Air Quality Threshold: \(config.warningThreshold)")
//                    .font(.subheadline)
//                    .foregroundColor(config.warningThreshold > 50 ? .red : .green)
//            }
//            
//            if let config = detector.doorSensorConfiguration {
//                Text("Polling Interval: \(config.pollingIntervalSeconds) sec")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(radius: 2)
//    }
//}
//struct DetectorEditView: View {
//    @State private var detector: Detector
//    @State private var isLoading = false
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        Form {
//            Section(header: Text("Air Quality Settings")) {
//                if let config = detector.airQualitySensorConfiguration {
//                    TextField("Calibration Factor", value: .constant(config.calibrationFactor), format: .number)
//                    TextField("Warning Threshold", value: .constant(config.warningThreshold), format: .number)
//                }
//            }
//            
//            Section(header: Text("Door Sensor Settings")) {
//                if let config = detector.doorSensorConfiguration {
//                    TextField("Polling Interval", value: .constant(config.pollingIntervalSeconds), format: .number)
//                    TextField("Sensitivity", value: .constant(config.sensitivity), format: .number)
//                }
//            }
//            
//            Button(action: {
//                updateDetector()
//            }) {
//                Text("Save Changes")
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(12)
//            }
//            .disabled(isLoading)
//        }
//        .navigationTitle("Edit Detector")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//    
//    private func updateDetector() {
//        isLoading = true
//        DetectorService().updateDetector(detector) { result in
//            DispatchQueue.main.async {
//                isLoading = false
//                switch result {
//                case .success:
//                    presentationMode.wrappedValue.dismiss()
//                case .failure(let error):
//                    print("Error: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//}
