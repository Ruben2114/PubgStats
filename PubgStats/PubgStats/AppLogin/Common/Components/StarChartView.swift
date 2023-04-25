//
//  StarChartView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/4/23.
//

import UIKit

class RadarChartView: UIView {
    
    var labels: [String] = []
    var labelFontSize: CGFloat = 12.0
    var values: [CGFloat] = []
    var lineColor: UIColor = .black
    var margin: CGFloat = 20.0
    let labelOffset: CGFloat = 20.0
    
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
          let label = UILabel()
          label.text = labels[index]
          label.font = UIFont.systemFont(ofSize: labelFontSize)
          label.numberOfLines = 0
          self.addSubview(label)
          label.sizeToFit()
          var offsetPoint: CGPoint
          if index == 0 {
              offsetPoint = CGPoint(x: point.x, y: point.y - (labelOffset - 10))
          } else if index == 1{
              offsetPoint = CGPoint(x: point.x + (labelOffset + 10), y: point.y)
          }else if index == 2{
              offsetPoint = CGPoint(x: point.x, y: point.y + (labelOffset + 5))
          }else {
              offsetPoint = CGPoint(x: point.x + labelOffset * sin(angle * CGFloat(index)),
                                    y: point.y - labelOffset * cos(angle * CGFloat(index)))
          }
          label.center = offsetPoint
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

/*
 // Crea los botones en cada esquina de la gráfica
 let button = UIButton()


 // Asigna una imagen de menú desplegable a cada botón
 buttonTopLeft.setImage(UIImage(systemName: "chevron.down"), for: .normal)
 buttonTopRight.setImage(UIImage(systemName: "chevron.down"), for: .normal)
 buttonBottomLeft.setImage(UIImage(systemName: "chevron.down"), for: .normal)
 buttonBottomRight.setImage(UIImage(systemName: "chevron.down"), for: .normal)

 // Crea una función para mostrar el menú en la ubicación del botón tocado
 func showMenu(at location: CGPoint) {
     // Define las opciones del menú
     let option1 = UIAction(title: "Opción 1", handler: { _ in
         print("Opción 1 seleccionada")
     })
     let option2 = UIAction(title: "Opción 2", handler: { _ in
         print("Opción 2 seleccionada")
     })
     let option3 = UIAction(title: "Opción 3", handler: { _ in
         print("Opción 3 seleccionada")
     })

     // Crea el menú con las opciones
     let menu = UIMenu(title: "Selecciona una opción", children: [option1, option2, option3])

     // Muestra el menú en la ubicación del botón tocado
     menu.showMenu(from: self, rect: CGRect(origin: location, size: CGSize.zero))
 }

 // Asigna el menú creado al botón correspondiente
 button.menu = menu


 // Agrega la función para mostrar el menú al evento de toque del botón
 button.addTarget(self, action: #selector(handleMenuButtonTapped(_:)), for: .touchUpInside)


 // Función para manejar el evento de toque del botón
 @objc func handleMenuButtonTapped(_ sender: UIButton) {
        print("boton")
     

 */


