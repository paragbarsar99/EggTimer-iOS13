//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation
enum COOKING_TIME{
    case HARD;
    case MEDIUM;
    case SOFT
}

class ViewController: UIViewController {
    var avPlayer:AVAudioPlayer?
    var isCooking = false
    var WINDOW_WIDTH:CGFloat? = nil
    var lable = UILabel();
    var sliderOff:NSLayoutConstraint?
    var sliderOn:NSLayoutConstraint?
    let HStack:UIStackView = {
        let stack = UIStackView();
        stack.axis = .horizontal;
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func imageGenerator(image:String,type:COOKING_TIME) -> UIButton{
        let img = UIButton()
        let imageSource = UIImage(named: image)
        
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.setImage(imageSource, for: .normal)

        img.widthAnchor.constraint(equalToConstant: 90).isActive = true;
        img.heightAnchor.constraint(equalToConstant: 110).isActive = true;
        img.addAction(UIAction {_ in
            self.onChangeCookingType(type: type)
        } , for: .touchUpInside)
        return img
    }
    
   lazy var onShowTimerIndicator:UIView = {
        var view = UIView();
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true;
        view.backgroundColor = .yellow;
        view.layer.cornerRadius = 6
        return view
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#87CEFA");
        view.addSubview(HStack);
        view.addSubview(lable)
        view.addSubview(onShowTimerIndicator)
        WINDOW_WIDTH = view.frame.width
        lable.translatesAutoresizingMaskIntoConstraints = false;
        lable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        lable.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 140).isActive = true
        lable.numberOfLines = 0;
        lable.textColor = .white;
        lable.text = "Start Cooking"
        lable.textAlignment = .center
        lable.font = .systemFont(ofSize: 22, weight: .bold)
        HStack.addArrangedSubview(imageGenerator(image: "soft_egg",type: COOKING_TIME.SOFT))
        HStack.addArrangedSubview(imageGenerator(image: "medium_egg",type: COOKING_TIME.MEDIUM))
        HStack.addArrangedSubview(imageGenerator(image: "hard_egg",type: COOKING_TIME.HARD))
        HStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        HStack.centerYAnchor.constraint(equalTo: lable.bottomAnchor, constant: 200).isActive = true
        onShowTimerIndicator.centerYAnchor.constraint(equalTo: HStack.bottomAnchor,constant: 200).isActive = true;
     
        onShowTimerIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        sliderOff = onShowTimerIndicator.widthAnchor.constraint(equalToConstant: 0)
        sliderOff?.isActive = true;
        sliderOn = onShowTimerIndicator.widthAnchor.constraint(equalToConstant: view.frame.width - 40);
    
        
    }
    
    func onDoneCooking(){
        if let sound = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3"){
            do{
                avPlayer = try AVAudioPlayer(contentsOf: sound)
                avPlayer?.prepareToPlay();
                avPlayer?.play()
            }catch{
                printContent("DEBUG: \(error) in side onDoneCooking")
            }
          
        }
    }
    func onStartTimer(_ second:TimeInterval){
//       guard let windowWidth = WINDOW_WIDTH else {
//           return;
//       }
       
            isCooking.toggle()
            sliderOff?.isActive.toggle();
            sliderOn?.isActive.toggle();
      
        UIView.animate(withDuration: second, animations: {
            self.onShowTimerIndicator.superview?.layoutIfNeeded()
            
        }){ finished in
            if finished {
                self.lable.text = "Ready To Eat!"
                self.sliderOff?.isActive.toggle();
                self.sliderOn?.isActive.toggle();
                self.isCooking.toggle()
                self.onDoneCooking()
                
            }
        }
    }
    
    func onChangeCookingType(type:COOKING_TIME){
        if(isCooking){
            return;
        }
        
        switch type {
        case .HARD:
            onStartTimer(5.0)
            lable.text = "Hard Cooking..\nwill take 5 second"
            break;
        case .MEDIUM:
            onStartTimer(3.0)
            lable.text = "Medium Cooking..\nwill take 3 second"
            break;
        case .SOFT:
            onStartTimer(1.0)
            lable.text = "Soft Cooking..\nwill take 1 second"
            
        }
    }
 }

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
#Preview {
    ViewController()
}


