//
//  ViewController.swift
//  FrolovSowingo
//
//  Created by Mikhail Frolov on 2022-01-02.
//

import UIKit
import CoreData


class ViewController: UIViewController {
   
    enum Section: Hashable {
    
        case cell
    
    }
    
    private let viewModel = ViewModel()
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    var favouriteProductProvider: FavouriteProductProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFavouriteProductProvider()
        setupView()
        setupNavigationBar()
        configureDataSource()
        fetchProducts()
        configureSearchController()
    }
    
    // fetching products
    private func fetchProducts() {
  
        Task {
            do {
                let products = try await self.viewModel.fetchProducts()
                self.setSnapshot(with: products)
            } catch {
                print("Error while fetching products")
            }
        }
    }
}

// adding functions to setup the View, NavBar etc.
extension ViewController {
    
    // view
    private func setupView() {
       
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: CollectionLayout.createCollectionLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
    
    }
    
    // NavBar
    private func setupNavigationBar() {
       
        title = "Products"
      
        // sorting options
        let defaultSort = UIAction(title: "Default") { [weak self] _ in
            guard let self = self else { return }
            self.fetchProducts()
        }
        
        let sortByFavourited = UIAction(title: "Favourited Product") { [weak self] _ in
            guard let self = self else { return }
            for favouriteProduct in self.viewModel.favoriteProducts {
                self.viewModel.products.sort(by: { $0.id == favouriteProduct.productID && $1.id != favouriteProduct.productID })
            }
            
            self.setSnapshot(with: self.viewModel.products, animated: true)
        }
        
        let sortByNameOption = UIAction(title: "Product Name") { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.products.sort(by: { $1.name > $0.name })
            self.setSnapshot(with: self.viewModel.products, animated: true)
        }
        
        let sortByAscPriceOption = UIAction(title: "Price Asc.") { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.products.sort(by: { $1.vendorInventory.first!.price > $0.vendorInventory.first!.price })
            self.setSnapshot(with: self.viewModel.products, animated: true)
        }
       
        let sortByDescPriceOption = UIAction(title: "Price Desc.") { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.products.sort(by: { $0.vendorInventory.first!.price > $1.vendorInventory.first!.price })
            self.setSnapshot(with: self.viewModel.products, animated: true)
        }
        
        var sortMenu: UIMenu
        sortMenu = UIMenu(title: "Filter by", options: [.displayInline, .singleSelection], children: [defaultSort, sortByFavourited, sortByNameOption, sortByAscPriceOption, sortByDescPriceOption])
        
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: UIMenu(title: "", children: [sortMenu]))
        self.navigationItem.rightBarButtonItem = sortButton
    }
}

extension ViewController: UICollectionViewDelegate {
 
    private func configureDataSource() {
       
        let cellRegistration = UICollectionView.CellRegistration<ProductCell, Product> { cell, indexPath, product in
            cell.favorite = self.viewModel.getSavedFavouriteProduct(for: product.id)
            cell.product = product
            cell.delegate = self
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView){ collectionView, indexPath, product in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
    }
    
    // to reflect changes in UI later
    private func setSnapshot(with products: [Product], animated: Bool = false) {
       
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.cell])
        snapshot.appendItems(products, toSection: .cell)
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func reloadData() {
       
        let snapshot = dataSource.snapshot()
        dataSource.applySnapshotUsingReloadData(snapshot)
      
    }
    
}

extension ViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
   
    private func configureSearchController() {
     
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Product Name"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = false
       
        navigationItem.searchController = searchController
    
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
          
            viewModel.filteredProducts.removeAll()
            setSnapshot(with: viewModel.products, animated: true)
            
            return
        
        }
        
        viewModel.filteredProducts = viewModel.products.filter { product in
        
            return product.name.lowercased().contains(filter.lowercased())
        
        }
        
        setSnapshot(with: viewModel.filteredProducts, animated: true)
    
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    
        viewModel.filteredProducts.removeAll()
        setSnapshot(with: viewModel.products, animated: true)
    
    }
}

extension ViewController: FavoriteButtonDelegate {
    
    func didToggleFavoriteButton(for id: String) {
        let check = viewModel.isFavourited(for: id)
        
        Task {
            
            do {
            
                let favorite = try await viewModel.setFavourite(selected: !check)
                
                if favorite.favorite == false {
                
                    self.favouriteProductProvider.saveFavouriteProduct(productID: id, isFavourite: true)
                
                } else {
                
                    guard let savedFavouriteProduct = self.viewModel.getSavedFavouriteProduct(for: id) else { return }
                    self.favouriteProductProvider.removeFavouriteProduct(savedFavouriteProduct)
                
                }
            } catch {
                print(error)
            }
        }
    }
   
}

extension ViewController: NSFetchedResultsControllerDelegate {
  
    private func configureFavouriteProductProvider() {
    
        favouriteProductProvider = FavouriteProductProvider(storageContainer: StorageContainer(), delegate: self)
        viewModel.favoriteProducts = favouriteProductProvider.getAllFavouriteProducts()
    
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        guard let fetchedFavouriteProducts = controller.fetchedObjects as? [FavouriteProduct] else { return }
        
        switch type {
        case .delete, .insert:
            viewModel.favoriteProducts = fetchedFavouriteProducts
            self.reloadData()
        default:
            break
        }
    }
}
