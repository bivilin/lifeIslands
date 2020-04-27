//
//  AllIslandsViewController.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 24/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class IslandsViewController: UIViewController {
    
    @IBOutlet weak var islandsSCNView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SCNScene
        let islandsSCNScene = SCNScene(named: "AllIslandsScene.scn")!
        setUpCameraControl(sceneView: self.islandsSCNView)
        
        // Create the SKScene
        let selfIslandSKScene = SKScene(fileNamed: "IslandSpriteScene.sks")!
        selfIslandSKScene.isPaused = false
        selfIslandSKScene.scaleMode = .aspectFit
        
        // Set SpriteKit scene as the material for the SceneKit plane
        if let selfIslandPlane = islandsSCNScene.rootNode.childNode(withName: "selfIslandPlane", recursively: true),
            let geometry = selfIslandPlane.geometry,
            let material = geometry.firstMaterial {
            
            material.diffuse.contents = selfIslandSKScene
            material.isDoubleSided = true
        }
        
        // Passos para criar as outras ilhas
        // 1: Adicionar planos ao SceneKit programaticamente correspondendo às ilhas
        // 2: Criar cena no SpriteKit programaticamente (ou podemos reaproveitar a mesma SKScene?)
        // 3: Associar as duas
        // 4: Conectar com as informações persistidas do CoreData

        // DICIONÁRIO: NOME DA ILHA (chave) -> SPRITEKIT
        // Fazer array de planos, cada um com uma textura do SpriteKit
        // SpriteKit -> podemos fazer o sks herdar de uma classe -
        // Fazer uma SKScene para cada ilha, já que teremos um número máximo
        
        // CÂMERA
        // Mover a câmera com pinch e pan
        // Limitar o movimento dessa câmera com constraints
        // Escrever uma função que dependendo da posição da câmera mostra um card específico
        // OU
        // Cordinhas: joint (articulação) -> colocar efeitos de física
        // Colocar um corpo de física maior que a corda e transparente para a pessoa tocar
        
        // SceneKit camera
        // let cameraNode = islandsSCNScene.rootNode.childNode(withName: "camera", recursively: true)
        
        // Set the scene to the view
        self.islandsSCNView.scene = islandsSCNScene
        
    }
    
    func setUpCameraControl(sceneView: SCNView) {
        // Allows the user to manipulate the camera
        // Olhar constraints de câmera
        sceneView.allowsCameraControl = true
        sceneView.cameraControlConfiguration.rotationSensitivity = 0
    }
}
