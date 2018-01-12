//
//  UIScrollView+Rx.swift
//  SwiftInfoCollector
//
//  Created by stakata on 2017/12/16.
//  Copyright © 2017年 officekoma. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIScrollView {
    var reachBottom: ControlEvent<Void> {
        let observable = contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Void> in
                guard let scrollView = base else {
                    return Observable.empty()
                }
                
                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
                
                return y > threshold ? Observable.just(Void()) : Observable.empty()
        }
        return ControlEvent(events: observable)
    }
}
