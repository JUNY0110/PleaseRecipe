//
//  Compositionable.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/3/24.
//

import UIKit


protocol Compositionable {
    func configureCollectionView()
    func createDataSource()
    
    func createCompositionalLayout(columns: CGFloat) -> UICollectionViewLayout
    func createCompositionalLayout(columns: CGFloat, height: CGFloat, headerElementKind: String) -> UICollectionViewLayout
}

extension Compositionable where Self: UIViewController {
    func createCompositionalLayout() -> UICollectionViewLayout {
        let item = configureItem(width: .estimated(200), height: .absolute(30))
        
        let group = configureGroup(width: .fractionalWidth(1.0),
                                   height: .absolute(30),
                                   interItemSpacing: 8,
                                   subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical

        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = config
        return layout
    }
    
    func createCompositionalLayout(columns: CGFloat) -> UICollectionViewLayout {
        let spacing: CGFloat = 12
        let safeArea: CGFloat = 16
        let size = (self.view.bounds.width - 2*safeArea - (columns-1)*spacing) / columns
        
        // MARK: Item
        let item = self.configureItem(width: .absolute(size), height: .absolute(size))
        
        // MARK: Group
        let group = self.configureGroup(width: .fractionalWidth(1.0),
                                        height: .absolute(size),
                                        interItemSpacing: spacing,
                                        subitems: [item])
        
        // MARK: Section
        let section = self.configureSection(interGroupSpacing: spacing,
                                            safeArea: safeArea,
                                            group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func createCompositionalLayout(columns: CGFloat, height: CGFloat, headerElementKind: String) -> UICollectionViewLayout {

        let spacing: CGFloat = 12
        let safeArea: CGFloat = 16
        let width = (self.view.bounds.width - 2*safeArea - (columns-1)*spacing) / columns
        
        // MARK: Item
        let item = self.configureItem(width: .absolute(width), height: .absolute(height))
        
        // MARK: Group
        let group = self.configureGroup(width: .fractionalWidth(1.0),
                                        height: .absolute(height),
                                        interItemSpacing: spacing,
                                        subitems: [item])
        
        // MARK: Section
        let section = self.configureSection(interGroupSpacing: spacing,
                                            safeArea: safeArea,
                                            group: group)
        
        // MARK: Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: headerElementKind,
                                                                        alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}


extension Compositionable {
    private func configureItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: width,
                                              heightDimension: height)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        return item
    }
    
    private func configureGroup(
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        interItemSpacing: CGFloat,
        subitems: [NSCollectionLayoutItem]
    ) -> NSCollectionLayoutGroup {
            // 가로를 기준으로 하나의 그룹으로 묶고,높이를 통일함.
        let groupSize = NSCollectionLayoutSize(widthDimension: width,
                                               heightDimension: height)
        
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: subitems
        )
        
        group.interItemSpacing = .fixed(interItemSpacing) // 아이템 그룹 내 좌우 아이템 사이 여백
        
        return group
    }
    
    private func configureSection(
        interGroupSpacing: CGFloat,
        safeArea: CGFloat,
        group: NSCollectionLayoutGroup
    ) -> NSCollectionLayoutSection {
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpacing // 아이템 그룹 내 상하 아이템 사이 여백
        section.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                        leading: safeArea,
                                                        bottom: 24,
                                                        trailing: safeArea) // 섹션별 inset)
        return section
    }
    
    private func makeHeaderView(_ elementKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: elementKind,
                                                                 alignment: .top)
        return header
    }
}
