//
//  StarChartView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/4/23.
//

import UIKit

class RadarChartView: UIView {
    
    var buttonsTitle: [String] = []
    var buttonFontSize: CGFloat = 12.0
    var values: [CGFloat] = []
    var lineColor: UIColor = .black
    var margin: CGFloat = 20.0
    let buttonOffset: CGFloat = 20.0
    var buttons: [UIButton] = []
    init(values: [CGFloat], buttonsTitle: [String]) {
        super.init(frame: .zero)
        self.values = values
        self.buttonsTitle = buttonsTitle
        configureView()
    }
    @available(*,unavailable)//este init no se puede utilizar para que nunca llegue el fatal error
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        buttonsTitle.forEach { title in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.titleLabel?.numberOfLines = 0
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            self.addSubview(button)
            buttons.append(button)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //coordenadas de los vértices de la gráfica de estrella
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - margin
        let angle = CGFloat.pi * 2 / CGFloat(values.count)
        var vertices: [CGPoint] = []
        for i in 0..<values.count {
            let vertex = CGPoint(x: center.x + radius * sin(angle * CGFloat(i)),
                                 y: center.y - radius * cos(angle * CGFloat(i)))
            vertices.append(vertex)
        }
        
        let path = UIBezierPath()
        for i in 0..<vertices.count {
            let vertex = vertices[i]
            if i == 0 {
                path.move(to: vertex)
            } else {
                path.addLine(to: vertex)
            }
        }
        path.close()
        //UIColor.systemGroupedBackground.setFill()
        UIColor(red: 0, green: 1, blue: 0, alpha: 0.5).setFill()
        path.fill()
        
 
         for (index, point) in vertices.enumerated() {
             let button = buttons[index]
             button.tag = index
             button.sizeToFit()
             var offsetPoint: CGPoint
             if index == 0 {
                 offsetPoint = CGPoint(x: point.x + buttonOffset * sin(angle * CGFloat(index)),
                                       y: point.y - 10 * cos(angle * CGFloat(index)))
               
             }else {
                 offsetPoint = CGPoint(x: point.x + buttonOffset * sin(angle * CGFloat(index)),
                                       y: point.y - buttonOffset * cos(angle * CGFloat(index)))
             }
             button.center = offsetPoint
         }
        
        // círculo central
        let circlePath = UIBezierPath(arcCenter: center, radius: 5, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        UIColor.lightGray.setFill()
        circlePath.fill()
        
        
        // coordenadas de los vértices de la gráfica de radar
        var points: [CGPoint] = []
        for i in 0..<values.count {
            let value = values[i]
            let point = CGPoint(x: center.x + radius * sin(angle * CGFloat(i)) * value,
                                y: center.y - radius * cos(angle * CGFloat(i)) * value)
            points.append(point)
        }
        
        // líneas que conectan los vértices de la gráfica de radar
        let path2 = UIBezierPath()
        for i in 0..<points.count {
            let point = points[i]
            if i == 0 {
                path2.move(to: point)
            } else {
                path2.addLine(to: point)
            }
        }
        path2.close()
        
        // área de relleno
        lineColor.setStroke()
        lineColor.setFill()
        path2.stroke()
        path2.fill(with: .normal, alpha: 0.5)
        
        // puntos que representan los valores de cada variable
        for i in 0..<points.count {
            let point = points[i]
            let dotPath = UIBezierPath(arcCenter: point, radius: 3.0, startAngle: 0.0, endAngle: CGFloat.pi * 2, clockwise: true)
            lineColor.setFill()
            dotPath.fill()
        }
    }
}


