//
//  GraphView.swift
//  GBMCodeChallenge
//
//  Created by Armand on 10/12/21.
//

import UIKit

class GraphView: UIView {
    
    var graphPoints: [Double] = []
    var timeSelectorPosition: Int = -1

    override func draw(_ rect: CGRect) {
        
//        self.backgroundColor = .yellow
        
        let width = rect.width
        let height = rect.height
        
        let margin = 40.0
        let topBorder = 20.0
        let bottomBorder = 20.0
        
        let graphPath = UIBezierPath()
        
        let graphWidth = width
        
        let graphHeight = height
        guard let maxValue = graphPoints.max(), let minValue = graphPoints.min() else {
          return
        }
        
        // Draw horizontal Lines
        let horizontalPath = UIBezierPath()
        for i in 1...4 {
            let y = graphHeight - (CGFloat(i) * ((graphHeight - topBorder - bottomBorder) / 5)) - bottomBorder
            horizontalPath.move(to: CGPoint(x: margin, y: y))
            horizontalPath.addLine(to: CGPoint(x: graphWidth - margin, y: y))
            UIColor.lightGray.set()
            horizontalPath.stroke()
            
            //Draw price labels
            let leftLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: y - 15), size: CGSize(width: 100, height: 30)))
            let rightLabel = UILabel(frame: CGRect(origin: CGPoint(x: graphWidth - 35, y: y - 15), size: CGSize(width: 60, height: 30)))
            let value = String(Int(minValue + ((maxValue - minValue) / 5) * CGFloat(i)))
            leftLabel.font = UIFont.boldSystemFont(ofSize: 12)
            rightLabel.font = UIFont.boldSystemFont(ofSize: 12)
            leftLabel.text = value
            rightLabel.text = value
            self.addSubview(leftLabel)
            self.addSubview(rightLabel)
        }
        
        // Draw Border
        let borderPath = UIBezierPath()
        borderPath.move(to: CGPoint(x: margin, y: 0))
        borderPath.addLine(to: CGPoint(x: graphWidth - margin, y: 0))
        borderPath.addLine(to: CGPoint(x: graphWidth - margin, y: graphHeight))
        borderPath.lineWidth = 3
        UIColor.gray.set()
        borderPath.stroke()
        
        // Draw Graphic
        
        let columnXPoint = { (column: Int) -> CGFloat in
            let spacing = (graphWidth - margin * 2) / CGFloat(self.graphPoints.count)
            return CGFloat(column) * spacing + margin
        }
        
        let columnYPoint = { (graphPoint: Double) -> CGFloat in
        let yPoint = ((CGFloat(graphPoint) - CGFloat(minValue)) * (graphHeight - topBorder - bottomBorder)) / (maxValue - minValue)
          return graphHeight - yPoint - bottomBorder// Flip the graph
        }
        
        UIColor.red.set()

        // Go to start of line
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
            
        // Add points for each item in the graphPoints array
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
          graphPath.addLine(to: nextPoint)
        }
        graphPath.stroke()
        
        // Draw Time Selector
        
        if timeSelectorPosition >= 0 {
            UIColor.systemGreen.set()
            let timePath = UIBezierPath()
            timePath.move(to: CGPoint(x: columnXPoint(timeSelectorPosition), y: 0))
            timePath.addLine(to: CGPoint(x: columnXPoint(timeSelectorPosition), y: graphHeight))
            timePath.stroke()
        }
    }
    
    func updateGraph(with values: [Double] = []) {
        graphPoints = values
        DispatchQueue.main.async { [weak self] in
            self?.setNeedsDisplay()
        }
    }
    
    func addTimeSelector(position: Int) {
        timeSelectorPosition = position
        self.setNeedsDisplay()
    }
}
