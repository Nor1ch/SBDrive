//
//  TableViewProtocol.swift
//  Diplom
//
//  Created by Nor1 on 23.07.2022.
//

import Foundation
import UIKit

protocol TableViewProtocol {
    var arrayForTableView : [DiskFileModel] { get set }
    var viewModel : FilesViewModel {get}
    var path : String {get}
    var vc : UIViewController? {get}
}

class TableViewForDelegate : NSObject, TableViewProtocol, UITableViewDelegate, UITableViewDataSource {
    var vc: UIViewController?
    var arrayForTableView: [DiskFileModel]
    var viewModel: FilesViewModel
    var path: String
    
    
    init(array: [DiskFileModel], model: FilesViewModel, path: String) {
        self.arrayForTableView = array
        self.viewModel = model
        self.path = path
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
        return arrayForTableView.count
        } else if section == 1 {
            return 1
        } else {
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else {
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell
        let usage = arrayForTableView[indexPath.row]
            if usage.size == nil {
                cell?.getSize().text = ""
            } else {
                cell?.getSize().text = "\(String(usage.size ?? 000))" + " мб"
            }
        cell?.getTitle().text = usage.name
        cell?.getTime().text = usage.created
        cell?.getImage().image = UIImage()
        cell?.getIndicator().startAnimating()
            
            if viewModel.typeVC == "Posted"{
                cell?.getButton().isHidden = false
                if self.vc != nil {
                let alertVC = UIAlertController(title: usage.name, message: nil, preferredStyle: .actionSheet)
                    let alertError = UIAlertController(title: Constants.Text.Published.error, message: Constants.Text.Published.errorMessage, preferredStyle: .alert)
                    alertError.addAction(UIAlertAction(title: Constants.Text.Sheet.ok, style: .default, handler: nil))
                    alertVC.addAction(UIAlertAction(title: Constants.Text.Published.deletePublishing, style: .destructive){_ in
                        self.viewModel.removePublished(path: self.arrayForTableView[indexPath.row].path ?? ""){ bool in
                            if bool == true {
                                self.arrayForTableView.remove(at: indexPath.row)
                                tableView.beginUpdates()
                                tableView.deleteRows(at: [indexPath], with: .fade)
                                tableView.endUpdates()
                                tableView.reloadData()
                            } else {
                                self.vc?.present(alertError, animated: true, completion: nil)
                            }
                        }
                    })
                    alertVC.addAction(UIAlertAction(title: Constants.Text.Sheet.cancel, style: .cancel, handler: nil))
                cell?.setupButton(alert: alertVC, vc: self.vc ?? UIViewController())
                }
            }
        switch usage.media_type {
        case nil:
            cell?.getImage().image = UIImage(named: "folder")
            cell?.getIndicator().stopAnimating()
        case "image":
            viewModel.networkService.getPreview(path: usage.preview ?? "") { image in
                cell?.getImage().image = image
                cell?.getIndicator().stopAnimating()
            }
        case "document":
            viewModel.networkService.getPreview(path: usage.preview ?? "") { image in
                cell?.getImage().image = image
                cell?.getIndicator().stopAnimating()
            }
        case "video":
            if usage.preview == nil {
            cell?.getImage().image = UIImage(named: "development")
            cell?.getIndicator().stopAnimating()
            } else {
            viewModel.networkService.getPreview(path: usage.preview ?? "") { image in
                    cell?.getImage().image = image
                    cell?.getIndicator().stopAnimating()
                }
            }
        case "audio":
            cell?.getIndicator().stopAnimating()
            cell?.getImage().image = UIImage(named: "music")
        default:
            cell?.getIndicator().stopAnimating()
            cell?.getImage().image = UIImage(named: "development")
            break
        }
            return cell ?? UITableViewCell() }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier, for: indexPath) as? LoadingCell
            if isLoading == true{
                cell?.getIndicator().startAnimating()}
            else {
                cell?.getIndicator().stopAnimating()
                cell?.isHidden = true
            }
            return cell ?? UITableViewCell()
        }
    }
    var isLoading = false
    var isEnd = false
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        if indexPath.row == arrayForTableView.count - 15, !isLoading, !isEnd{
            if !self.isLoading {
                self.isLoading = true
                self.isEnd = false
                switch viewModel.typeVC {
                case "Files":
                viewModel.networkService.getFolderFiles(path: self.path, offset: 15) { array in
                    guard let array = array else {
                        return
                    }

                    if array.isEmpty {
                        self.isLoading = false
                        self.isEnd = true
                        tableView.reloadData()
                    } else {
                self.arrayForTableView.append(contentsOf: array)
                tableView.reloadData()
                self.isLoading = false
                        }
                    }
                case "Recently" :
                    self.isLoading = true
                    self.isEnd = viewModel.getRecentlyFilesPadding()
                case "Posted" :
                    self.isEnd = viewModel.getPostedFilesPadding()
                    self.isLoading = false
                default:
                    break
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = arrayForTableView[indexPath.row]
        switch file.media_type {
        case nil:
            viewModel.openFolder(title: file.name ?? "ERROR", path: file.path ?? "ERROR")
        case "image":
            viewModel.openImage(title: file.name ?? "ERROR", path: file.file ?? "ERROR", date: file.created ?? "ERROR", onDisk: file.path ?? "ERROR", tableView: tableView)
        case "document":
            viewModel.openDoc(title: file.name ?? "ERROR", path: file.path ?? "ERROR", file: file.file ?? "ERROR")
            FilesViewModel.docVC = true
        default :
            break
        }
    }
}
