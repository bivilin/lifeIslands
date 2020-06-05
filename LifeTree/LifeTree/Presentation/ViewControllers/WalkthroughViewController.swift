//
//  WalkthroughViewController.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 01/06/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import UIKit

class WalkthroughViewController: UIViewController {
    
    // MARK: Variables
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var pages: [WalkthroughPage] = [];
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        self.pages = self.createPages()
        
        self.setUpPagedScrollView()
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = 0
        self.view.bringSubviewToFront(self.pageControl)
    }
    
    // MARK: Set up pages in scrollView
    
    func setUpPagedScrollView() {
        
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(self.pages.count), height: self.view.frame.height)
        self.scrollView.isPagingEnabled = true
        
        for i in 0 ..< pages.count {
            pages[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(pages[i])
        }
    }
    
    func createPages() -> [WalkthroughPage] {
        let page1: WalkthroughPage = Bundle.main.loadNibNamed("WalkthroughPageView", owner: self, options: nil)?.first as! WalkthroughPage
        page1.imageView.image = UIImage(named: "Asset1_onboarding")
        page1.titleLabel.text = "Visualize as áreas da sua vida"
        page1.descriptionLabel.text = "Você terá uma ilha para área da sua vida e conseguirá navegar entre elas arrastando a tela vertical e horizontalmente"
        page1.startButton.isHidden = true
        
        let page2: WalkthroughPage = Bundle.main.loadNibNamed("WalkthroughPageView", owner: self, options: nil)?.first as! WalkthroughPage
        page2.imageView.image = UIImage(named: "Asset6_onboarding")
        page2.titleLabel.text = "Adicione atividades para cuidar da sua ilha"
        page2.descriptionLabel.text = "Suas atividades servirão de parâmetro para acompanhar seu progresso e de estímulo para cuidar das áreas da sua vida."
        page2.startButton.isHidden = true
        
        let page3: WalkthroughPage = Bundle.main.loadNibNamed("WalkthroughPageView", owner: self, options: nil)?.first as! WalkthroughPage
        page3.imageView.image = UIImage(named: "Asset7_onboarding")
        page3.titleLabel.text = "Ganhe recompensas e cultive sua ilha"
        page3.descriptionLabel.text = "Ao realizar tarefas, você ganhará gotas para regar sua ilha. Quanto mais você regar, mais saudável ela ficará."
        page3.startButton.isHidden = true
        
        let page4: WalkthroughPage = Bundle.main.loadNibNamed("WalkthroughPageView", owner: self, options: nil)?.first as! WalkthroughPage
        page4.imageView.image = UIImage(named: "Asset8_onboarding")
        page4.titleLabel.text = "Você está no centro"
        page4.descriptionLabel.text = "A ilha central representa VOCÊ, e a saúde dela é o reflexo de todas as outras ilhas. Portanto, não esqueça nenhuma delas."
        page4.startButton.isHidden = true
        
        let page5: WalkthroughPage = Bundle.main.loadNibNamed("WalkthroughPageView", owner: self, options: nil)?.first as! WalkthroughPage
        page5.imageView.image = UIImage(named: "Asset2_onboarding")
        page5.titleLabel.text = "As estações são seu guia"
        page5.descriptionLabel.text = "Acompanhe a saúde de cada ilha e saiba qual priorizar. O verão representa o estado mais saudável, mas não se esqueça que mesmo o inverno faz parte do ciclo natural da vida!"
        page5.startButton.layer.cornerRadius = 10
        page5.walkthroughDelegate = self
        
        return [page1, page2, page3, page4, page5]
    }
}

// MARK: Walkthrough delegate

extension WalkthroughViewController: WalkthroughDelegate {
    func didPressStartButton() {
        performSegue(withIdentifier: "fromWalkthroughToSelectIsland", sender: self)
    }
}

// MARK: ScrollView delegate

extension WalkthroughViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Changes page index on pageControl
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        self.pageControl.currentPage = Int(pageIndex)
        
        // Calculate relative horizontal displacement on scrollView
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        // Scales the imageview on paging the scrollview
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            
            self.pages[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            self.pages[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
            
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            self.pages[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            self.pages[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
            
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            self.pages[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            self.pages[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
            
        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            self.pages[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
            self.pages[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
        }
    }
}
