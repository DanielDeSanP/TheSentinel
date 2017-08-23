//
//  customButtom.swift
//  The Sentinel
//
//  Created by Luis  Daniel De San Pedro on 14/02/16.
//  Copyright © 2016 Daniel De San Pedro V. All rights reserved.
//

import UIKit

@IBDesignable

class customButtom: UIButton {

    //Estas funciones siempre tienen que ser agregadas
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0 { //las variables CG designan coordenadas
        didSet{
            setupView()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable var borderRadius: CGFloat = 0 {
        didSet{
            setupView()
        }
    }
    
    
    func setupView() {
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = borderRadius
        self.backgroundColor = UIColor.clear
        
    }

}
