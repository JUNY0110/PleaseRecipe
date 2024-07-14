//
//  IngredientSearchModels.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/1/24.
//

import UIKit


enum Vegetables: String, IngredientProtocol {
    case 가지
    case 감자
    case 고추
    case 당근
    case 대추
    case 대파
    case 쪽파
    case 실파
    case 양파
    case 마늘
    case 무
    case 열무
    case 버섯
    case 느타리버섯
    case 능이버섯
    case 팽이버섯
    case 표고버섯
    case 송이버섯
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
    case 단호박
    case 애호박
    case 깻잎
    case 쑥
    
    var name: String {
        return self.rawValue
    }
    
    var image: UIImage {
        switch self {
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
        case .쪽파:
            return UIImage(resource: .대파)
        case .실파:
            return UIImage(resource: .대파)
        case .양파:
            return UIImage(resource: .양파)
        case .마늘:
            return UIImage(resource: .마늘)
        case .무:
            return UIImage(resource: .무)
        case .열무:
            return UIImage(resource: .무)
        case .버섯:
            return UIImage(resource: .버섯)
        case .느타리버섯:
            return UIImage(resource: .버섯)
        case .능이버섯:
            return UIImage(resource: .버섯)
        case .팽이버섯:
            return UIImage(resource: .버섯)
        case .표고버섯:
            return UIImage(resource: .버섯)
        case .송이버섯:
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
        case .단호박:
            return UIImage(resource: .호박)
        case .애호박:
            return UIImage(resource: .호박)
        case .깻잎:
            return UIImage(resource: .잎)
        case .쑥:
            return UIImage(resource: .쑥)
        }
    }
}

enum Fruit: String, IngredientProtocol {
    case 감
    case 귤
    case 딸기
    case 레몬
    case 매실
    case 멜론
    case 파인애플
    case 포도
    
    var name: String {
        return self.rawValue
    }
    
    var image: UIImage {
        switch self {
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
        }
    }
}

enum Pork: String, IngredientProtocol {
    case 돼지고기
    case 돼지고기_안심
    case 돼지고기_등심
    case 돼지고기_목심
    case 돼지고기_앞다리
    case 돼지고기_뒷다리
    case 돼지고기_삼겹살
    case 돼지고기_갈비
    
    var name: String {
        switch self {
        case .돼지고기:
            return "돼지고기"
        case .돼지고기_안심:
            return "돼지고기(안심)"
        case .돼지고기_등심:
            return "돼지고기(등심)"
        case .돼지고기_목심:
            return "돼지고기(목심)"
        case .돼지고기_앞다리:
            return "돼지고기(전지)"
        case .돼지고기_뒷다리:
            return "돼지고기(후지)"
        case .돼지고기_삼겹살:
            return "돼지고기(삼겹)"
        case .돼지고기_갈비:
            return "돼지고기(갈비)"
        }
    }
    
    var image: UIImage {
        return UIImage(resource: .고기)
    }
}


enum Beef: String, IngredientProtocol {
    case 소고기
    case 소고기_갈비
    case 소고기_안심
    case 소고기_채끝
    case 소고기_등심
    case 소고기_목심
    case 소고기_앞다리
    case 소고기_뒷다리
    case 소고기_사태
    case 소고기_우둔
    case 소고기_설도
    case 소고기_양지
    
    var name: String {
        switch self {
        case .소고기:
            return "소고기"
        case .소고기_갈비:
            return "소고기(갈비)"
        case .소고기_안심:
            return "소고기(안심)"
        case .소고기_채끝:
            return "소고기(채끝)"
        case .소고기_등심:
            return "소고기(등심)"
        case .소고기_목심:
            return "소고기(목심)"
        case .소고기_앞다리:
            return "소고기(전지)"
        case .소고기_뒷다리:
            return "소고기(후지)"
        case .소고기_사태:
            return "소고기(사태)"
        case .소고기_우둔:
            return "소고기(우둔)"
        case .소고기_설도:
            return "소고기(설도)"
        case .소고기_양지:
            return "소고기(양지)"
        }
    }
    
    var image: UIImage {
        return UIImage(resource: .고기)
    }
}

enum Chicken: String, IngredientProtocol {
    case 닭고기
    case 닭고기_다리
    case 닭고기_윙
    case 닭고기_봉
    case 닭고기_닭발
    case 닭고기_가슴살
    case 닭고기_안심
    case 닭고기_닭목
    
    var name: String {
        switch self {
        case .닭고기:
            return "닭고기"
        case .닭고기_다리:
            return "닭고기(다리)"
        case .닭고기_윙:
            return "닭고기(윙)"
        case .닭고기_봉:
            return "닭고기(봉)"
        case .닭고기_닭발:
            return "닭고기(발)"
        case .닭고기_가슴살:
            return "닭고기(가슴)"
        case .닭고기_안심:
            return "닭고기(안심)"
        case .닭고기_닭목:
            return "닭고기(목)"
        }
    }
    
    var image: UIImage {
        return UIImage(resource: .닭고기)
    }
}

enum CanFood: String, IngredientProtocol {
    case 스팸
    case 참치캔
    case 꽁치캔
    case 골뱅이
    
    var name: String {
        return self.rawValue
    }
    
    var image: UIImage {
        switch self {
        case .스팸:
            return UIImage(resource: .통조림)
        case .골뱅이:
            return UIImage(resource: .통조림)
        case .참치캔:
            return UIImage(resource: .물고기통조림)
        case .꽁치캔:
            return UIImage(resource: .물고기통조림)
        }
    }
}

enum Seafood: String, IngredientProtocol {
    case 갈치
    case 고등어
    case 꽁치
    case 도다리
    case 동태
    case 멸치
    case 명태
    case 연어
    case 전어
    case 조기
    case 참치
    case 참돔
    case 문어
    case 낙지
    case 쭈꾸미
    case 오징어
    case 게살
    case 꽃게
    case 홍게
    case 대게
    case 새우
    case 칵테일새우
    case 흰다리새우
    case 블랙타이거새우
    case 홍새우
    case 대하
    case 킹타이거새우
    case 다슬기
    case 소라
    case 참소라
    case 조개
    case 가리비
    case 굴
    case 꼬막
    case 바지락
    case 생합
    case 전복
    case 홍합
    case 미역
    case 다시마
    
    var name: String {
        return self.rawValue
    }
    
    var image: UIImage {
        switch self {
        case .갈치:
            return UIImage(resource: .생선2)
        case .고등어:
            return UIImage(resource: .생선2)
        case .꽁치:
            return UIImage(resource: .생선2)
        case .도다리:
            return UIImage(resource: .생선2)
        case .동태:
            return UIImage(resource: .생선2)
        case .멸치:
            return UIImage(resource: .생선2)
        case .명태:
            return UIImage(resource: .생선2)
        case .연어:
            return UIImage(resource: .생선1)
        case .전어:
            return UIImage(resource: .생선2)
        case .조기:
            return UIImage(resource: .생선2)
        case .참치:
            return UIImage(resource: .생선1)
        case .참돔:
            return UIImage(resource: .생선1)
            
        case .문어:
            return UIImage(resource: .문어)
        case .낙지:
            return UIImage(resource: .문어)
        case .쭈꾸미:
            return UIImage(resource: .문어)
        case .오징어:
            return UIImage(resource: .오징어)
            
        case .게살:
            return UIImage(resource: .게)
        case .꽃게:
            return UIImage(resource: .게)
        case .홍게:
            return UIImage(resource: .게)
        case .대게:
            return UIImage(resource: .게)
            
        case .새우:
            return UIImage(resource: .새우)
        case .칵테일새우:
            return UIImage(resource: .새우)
        case .흰다리새우:
            return UIImage(resource: .새우)
        case .블랙타이거새우:
            return UIImage(resource: .새우)
        case .홍새우:
            return UIImage(resource: .새우)
        case .대하:
            return UIImage(resource: .새우)
        case .킹타이거새우:
            return UIImage(resource: .새우)
            
        case .다슬기:
            return UIImage(resource: .소라)
        case .소라:
            return UIImage(resource: .소라)
        case .참소라:
            return UIImage(resource: .소라)
            
        case .조개:
            return UIImage(resource: .조개)
        case .가리비:
            return UIImage(resource: .가리비)
        case .굴:
            return UIImage(resource: .굴)
        case .꼬막:
            return UIImage(resource: .조개)
        case .바지락:
            return UIImage(resource: .조개)
        case .생합:
            return UIImage(resource: .조개)
        case .전복:
            return UIImage(resource: .조개)
        case .홍합:
            return UIImage(resource: .홍합)
            
        case .미역:
            return UIImage(resource: .미역)
        case .다시마:
            return UIImage(resource: .미역)
        }
    }
}

enum Minor: String, IngredientProtocol {
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
    
    var name: String {
        return self.rawValue
    }
    
    var image: UIImage {
        switch self {
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
        }
    }
}

enum Nut: String, IngredientProtocol {
    case 아몬드
    case 땅콩
    case 콩
    case 검은콩
    case 팥
    
    var name: String {
        return self.rawValue
    }
    
    var image: UIImage {
        switch self {
        case .아몬드:
            return UIImage(resource: .아몬드)
        case .땅콩:
            return UIImage(resource: .땅콩)
        case .콩:
            return UIImage(resource: .콩)
        case .검은콩:
            return UIImage(resource: .콩)
        case .팥:
            return UIImage(resource: .콩)
        }
    }
}


enum Condiment: String, IngredientProtocol {
    case 고추장
    case 청국장
    case 된장
    case 쌈장
    case 다진마늘
    case 케찹
    case 토마토소스
    case 소금
    case 설탕
    case 미원
    case 후추
    case 다시다
    case 고춧가루
    case 고추기름
    case 술
    case 맛술
    case 참기름
    case 간장
    case 진간장
    case 국간장
    case 맛간장
    case 양조간장
    case 식초
    case 올리고당
    case 물엿
    case 타르타르소스
    case 마요네즈
    case 머스타드
    case 돈까스소스
    case 데리야끼소스
    case 새우젓
    case 참치액젓
    case 까나리액젓
    case 오징어젓갈
    case 명란젓갈
    case 꿀
    
    var name: String {
        return self.rawValue
    }
    
    var image: UIImage {
        switch self {
        case .고추장:
            return UIImage(resource: .고추장)
        case .청국장:
            return UIImage(resource: .장독대)
        case .된장:
            return UIImage(resource: .장독대)
        case .쌈장:
            return UIImage(resource: .장독대)
        case .다진마늘:
            return UIImage(resource: .마늘)
        case .케찹:
            return UIImage(resource: .케찹)
        case .토마토소스:
            return UIImage(resource: .케찹)
        case .소금:
            return UIImage(resource: .하얀조미료)
        case .설탕:
            return UIImage(resource: .하얀조미료)
        case .미원:
            return UIImage(resource: .하얀조미료)
        case .후추:
            return UIImage(resource: .후추)
        case .다시다:
            return UIImage(resource: .후추)
        case .고춧가루:
            return UIImage(resource: .고춧가루)
        case .고추기름:
            return UIImage(resource: .고추기름)
        case .술:
            return UIImage(resource: .술)
        case .맛술:
            return UIImage(resource: .술)
        case .참기름:
            return UIImage(resource: .술)
        case .간장:
            return UIImage(resource: .간장)
        case .진간장:
            return UIImage(resource: .간장)
        case .국간장:
            return UIImage(resource: .간장)
        case .맛간장:
            return UIImage(resource: .간장)
        case .양조간장:
            return UIImage(resource: .간장)
        case .식초:
            return UIImage(resource: .식초)
        case .올리고당:
            return UIImage(resource: .물)
        case .물엿:
            return UIImage(resource: .물)
        case .타르타르소스:
            return UIImage(resource: .타르타르소스)
        case .마요네즈:
            return UIImage(resource: .마요네즈)
        case .머스타드:
            return UIImage(resource: .노란소스)
        case .돈까스소스:
            return UIImage(resource: .갈색소스)
        case .데리야끼소스:
            return UIImage(resource: .갈색소스)
        case .새우젓:
            return UIImage(resource: .갈색소스)
        case .참치액젓:
            return UIImage(resource: .갈색소스)
        case .까나리액젓:
            return UIImage(resource: .갈색소스)
        case .오징어젓갈:
            return UIImage(resource: .갈색소스)
        case .명란젓갈:
            return UIImage(resource: .갈색소스)
        case .꿀:
            return UIImage(resource: .꿀)
        }
    }
}

