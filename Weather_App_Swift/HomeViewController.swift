//
//  ViewController.swift
//  Weather_App_Swift
//
//  Created by E5000855 on 30/06/24.
//

import Foundation
import UIKit
import CoreLocation

class HomeViewController : UIViewController{
   //MARK: - Properties
    var viewModel : WeatherViewModel?{
        didSet{
            configure()
        }
    }
    
    private let backgroundsImageView = UIImageView()
   
    
    private var stackView = SearchStackView()
    private var generalStackView = UIStackView()
    
    private let statusImageView = UIImageView()
    private let temperatureLabel = UILabel()
    private let cityLabel = UILabel()
    
    
    private let locationManager = CLLocationManager()
    
    private let weatherService = WeatherService()
   
    
    
    //MARK: - Lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
        style()
        layout()
        configureLocation()
    }
}



//MARK: - Helpers
extension HomeViewController{

    private func style(){
        //backgrounds style
        backgroundsImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundsImageView.contentMode = .scaleAspectFill
        backgroundsImageView.image = UIImage(named: "background")
        
        
        
        //Stackview
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.delegate = self
       
        //GeneralStackView
        generalStackView.spacing = 2
        generalStackView.axis = .vertical
        generalStackView.translatesAutoresizingMaskIntoConstraints = false
        generalStackView.alignment = .trailing
        
        //statusImageView
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.image = UIImage(systemName: "sun.max")
        statusImageView.tintColor = .label
        
        
        //TemperatureLabel
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.systemFont(ofSize: 50)
        temperatureLabel.attributedText = attributedText(with: "15")
        
        //citylabel
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
        cityLabel.text = "Izmir"
        
        
    }
    
    private func layout(){
        view.addSubview(backgroundsImageView)
        view.addSubview(generalStackView)

        generalStackView.addArrangedSubview(stackView)
       
        
        
        generalStackView.addArrangedSubview(statusImageView)
        generalStackView.addArrangedSubview(temperatureLabel)
        generalStackView.addArrangedSubview(cityLabel)

        NSLayoutConstraint.activate([
            backgroundsImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: backgroundsImageView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: backgroundsImageView.bottomAnchor),
            
            //StackView

            generalStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            generalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            view.trailingAnchor.constraint(equalTo: generalStackView.trailingAnchor, constant: 8),

            stackView.widthAnchor.constraint(equalTo: generalStackView.widthAnchor),
           
           
            //StatusImageView Layot
            statusImageView.heightAnchor.constraint(equalToConstant: 85),
            statusImageView.widthAnchor.constraint(equalToConstant: 85),
            
            
        
        ])
    }
    
    
    
    private func attributedText(with text: String) -> NSMutableAttributedString{
        
        let attributedText = NSMutableAttributedString(string: text,attributes: [.foregroundColor:UIColor.label,.font:UIFont.boldSystemFont(ofSize: 75)])
        attributedText.append(NSAttributedString(string: "°C",attributes: [.font:UIFont.systemFont(ofSize: 50)]))
        return attributedText
    }
    
    private func configureLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
    }
    
    private func configure(){
        guard let viewModel = self.viewModel else {return}
      
        self.cityLabel.text = viewModel.city
        self.temperatureLabel.attributedText = attributedText(with: viewModel.temperatureString!)
        self.statusImageView.image = UIImage(systemName: viewModel.statusName)
        print(viewModel.id)
       
    }
    private func showErrorAlert(forErrormessage message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    private func parseError(error: ServiceError){
        switch error {
        case .serverError:
            showErrorAlert(forErrormessage: error.rawValue)
        case .decodingError:
            showErrorAlert(forErrormessage: error.rawValue)
        }
    }
    
}

//MARK: - CLocationManagerDelete
extension HomeViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        locationManager.stopUpdatingLocation()
        self.weatherService.fetchWeatherLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { result in
            switch result {
            case .success(let success):
                self.viewModel = WeatherViewModel(weatherModel: success)
            case .failure(let failure):
                self.parseError(error: failure)
            }
        }
    }
}

//MARK: - PROTOCOL SearchStackViewDelegate
extension HomeViewController : SearchStackViewDelegate{
    func updationLocation(_ searchStackView: SearchStackView) {
        self.locationManager.startUpdatingLocation()
    }
    
    func didFetchWeather(_ searchStackView: SearchStackView, weatherModel: WeatherModel) {
        self.viewModel = WeatherViewModel(weatherModel: weatherModel)
    }
    func didFailWithError(_ searcStackView: SearchStackView, error: ServiceError) {
        parseError(error: error)
    }
    
    
}
