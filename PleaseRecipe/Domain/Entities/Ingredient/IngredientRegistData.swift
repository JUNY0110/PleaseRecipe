//
//  IngredientRegistData.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/1/24.
//

import UIKit


enum IngredientRegistData: String, CaseIterable {
    case 채소
    case 고기
    case 생선
    case 닭고기
    case 계란
    case 가지
    case 감자
    case 고추
    case 당근
    case 대추
    case 대파
    case 양파
    case 마늘
    case 무
    case 버섯
    case 브로콜리
    case 상추
    case 아스파라거스
    case 배추
    case 알배추
    case 양배추
    case 오이
    case 콩나물
    case 토마토
    case 파프리카
    case 호박
    case 깻잎
    case 쑥
    case 감
    case 귤
    case 딸기
    case 레몬
    case 매실
    case 멜론
    case 파인애플
    case 포도
    case 통조림
    case 고기통조림
    case 물고기통조림
    case 참돔
    case 문어
    case 오징어
    case 게살
    case 새우
    case 다슬기
    case 조개
    case 가리비
    case 굴
    case 꼬막
    case 홍합
    case 미역
    case 김치
    case 두부
    case 라면
    case 만두
    case 빵
    case 소세지
    case 어묵
    case 요거트
    case 김
    case 김가루
    case 치즈
    case 파슬리
    case 아몬드
    case 땅콩
    case 콩
    case 고추장
    case 청국장
    case 다진마늘
    case 케찹
    case 미원
    case 후추
    case 고춧가루
    case 고추기름
    case 술
    case 간장
    case 식초
    case 올리고당
    case 타르타르소스
    case 마요네즈
    case 머스타드
    case 명란젓갈
    case 꿀
    case 치킨너겟
    case 요구르트
    
    var name: String {
        return self.rawValue
    }
    
    var image: UIImage {
        switch self {
        case .채소:
            return UIImage(resource: .채소)
        case .고기:
            return UIImage(resource: .고기)
        case .생선:
            return UIImage(resource: .생선2)
        case .닭고기:
            return UIImage(resource: .닭고기)
        case .계란:
            return UIImage(resource: .계란)
        case .가지:
            return UIImage(resource: .가지)
        case .감자:
            return UIImage(resource: .감자)
        case .고추:
            return UIImage(resource: .고추)
        case .당근:
            return UIImage(resource: .당근)
        case .대추:
            return UIImage(resource: .대추)
        case .대파:
            return UIImage(resource: .대파)
        case .양파:
            return UIImage(resource: .양파)
        case .마늘:
            return UIImage(resource: .마늘)
        case .무:
            return UIImage(resource: .무)
        case .버섯:
            return UIImage(resource: .버섯)
        case .브로콜리:
            return UIImage(resource: .브로콜리)
        case .상추:
            return UIImage(resource: .상추)
        case .아스파라거스:
            return UIImage(resource: .아스파라거스)
        case .배추:
            return UIImage(resource: .배추)
        case .알배추:
            return UIImage(resource: .알배추)
        case .양배추:
            return UIImage(resource: .양배추)
        case .오이:
            return UIImage(resource: .오이)
        case .콩나물:
            return UIImage(resource: .콩나물)
        case .토마토:
            return UIImage(resource: .토마토)
        case .파프리카:
            return UIImage(resource: .파프리카)
        case .호박:
            return UIImage(resource: .호박)
        case .깻잎:
            return UIImage(resource: .잎)
        case .쑥:
            return UIImage(resource: .쑥)
        case .감:
            return UIImage(resource: .감)
        case .귤:
            return UIImage(resource: .귤)
        case .딸기:
            return UIImage(resource: .딸기)
        case .레몬:
            return UIImage(resource: .레몬)
        case .매실:
            return UIImage(resource: .매실)
        case .멜론:
            return UIImage(resource: .멜론)
        case .파인애플:
            return UIImage(resource: .파인애플)
        case .포도:
            return UIImage(resource: .포도)
        case .통조림:
            return UIImage(resource: .통조림)
        case .고기통조림:
            return UIImage(resource: .고기통조림)
        case .물고기통조림:
            return UIImage(resource: .물고기통조림)
        case .참돔:
            return UIImage(resource: .생선1)
        case .문어:
            return UIImage(resource: .문어)
        case .오징어:
            return UIImage(resource: .오징어)
        case .게살:
            return UIImage(resource: .게)
        case .새우:
            return UIImage(resource: .새우)
        case .다슬기:
            return UIImage(resource: .소라)
        case .조개:
            return UIImage(resource: .조개)
        case .가리비:
            return UIImage(resource: .가리비)
        case .굴:
            return UIImage(resource: .굴)
        case .꼬막:
            return UIImage(resource: .조개)
        case .홍합:
            return UIImage(resource: .홍합)
        case .미역:
            return UIImage(resource: .미역)
            
        case .김치:
            return UIImage(resource: .김치)
        case .두부:
            return UIImage(resource: .두부)
        case .라면:
            return UIImage(resource: .라면)
        case .만두:
            return UIImage(resource: .만두)
        case .빵:
            return UIImage(resource: .빵)
        case .소세지:
            return UIImage(resource: .소세지)
        case .어묵:
            return UIImage(resource: .어묵)
        case .요거트:
            return UIImage(resource: .요거트)
        case .김:
            return UIImage(resource: .김)
        case .김가루:
            return UIImage(resource: .김가루)
        case .치즈:
            return UIImage(resource: .치즈)
        case .파슬리:
            return UIImage(resource: .파슬리)
            
        case .아몬드:
            return UIImage(resource: .아몬드)
        case .땅콩:
            return UIImage(resource: .땅콩)
        case .콩:
            return UIImage(resource: .콩)
        case .고추장:
            return UIImage(resource: .고추장)
        case .청국장:
            return UIImage(resource: .장독대)
        case .다진마늘:
            return UIImage(resource: .마늘)
        case .케찹:
            return UIImage(resource: .케찹)
        case .미원:
            return UIImage(resource: .하얀조미료)
        case .후추:
            return UIImage(resource: .후추)
        case .고춧가루:
            return UIImage(resource: .고춧가루)
        case .고추기름:
            return UIImage(resource: .고추기름)
        case .술:
            return UIImage(resource: .술)
        case .간장:
            return UIImage(resource: .간장)
        case .식초:
            return UIImage(resource: .식초)
        case .올리고당:
            return UIImage(resource: .물)
        case .타르타르소스:
            return UIImage(resource: .타르타르소스)
        case .마요네즈:
            return UIImage(resource: .마요네즈)
        case .머스타드:
            return UIImage(resource: .노란소스)
        case .명란젓갈:
            return UIImage(resource: .갈색소스)
        case .꿀:
            return UIImage(resource: .꿀)
        case .치킨너겟:
            return UIImage(resource: .치킨너겟)
        case .요구르트:
            return UIImage(resource: .요구르트)
        }
    }
    
    var category: IngredientSection {
        switch self {
        case .채소:
            return .채소
        case .고기:
            return .돼지고기
        case .생선:
            return .해산물
        case .닭고기:
            return .닭고기
        case .계란, .가지, .감자, .고추, .당근, .대추, .대파, .양파, .마늘, .무, .버섯, .브로콜리, .상추, .아스파라거스, .배추, .알배추, .양배추,.오이, .콩나물, .토마토, .파프리카, .호박, .깻잎, .쑥:
            return .채소
        case .감, .귤, .딸기, .레몬, .매실, .멜론, .파인애플, .포도:
            return .과일
        case .통조림, .고기통조림, .물고기통조림:
            return .통조림
        case .참돔, .문어, .오징어, .게살, .새우, .다슬기, .조개,.가리비, .굴, .꼬막, .홍합, .미역:
            return .해산물
        case .김치, .두부, .라면, .만두, .빵, .소세지, .어묵, .요거트, .김, .김가루, .치즈, .파슬리, .치킨너겟, .요구르트:
            return .부재료
        case .아몬드, .땅콩, .콩:
            return .견과류
        case .고추장, .청국장, .다진마늘, .케찹, .미원, .후추, .고춧가루, .고추기름, .술, .간장, .식초, .올리고당, .타르타르소스, .마요네즈, .머스타드, .명란젓갈, .꿀:
            return .조미료
        }
    }
}
