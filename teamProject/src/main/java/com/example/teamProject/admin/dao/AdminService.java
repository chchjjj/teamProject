package com.example.teamProject.admin.dao;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.teamProject.admin.mapper.AdminMapper;
import com.example.teamProject.admin.model.Admin;
import com.example.teamProject.user.model.User;

@Service
public class AdminService {
	
	@Autowired
	AdminMapper adminMapper;
	
	//1. 사용자 관리
	public HashMap<String, Object> SelectUserList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		//userlist 
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List <Admin> userList= adminMapper.userListSelect(map);
			resultMap.put("userList",userList);
			int totalRows=adminMapper.userCount(map);
			resultMap.put("totalRows",totalRows);
			resultMap.put("result","success");
		}catch(Exception e) {
			resultMap.put("result","fail");
			System.out.println(e.getMessage());		
		}	
		 return resultMap;
				
	}
	
	public HashMap<String, Object> DeleteUserList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt=adminMapper.userListDelete(map);
		resultMap.put("result","success");
		return resultMap;
	}
	
	public HashMap<String, Object> SelectUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		Admin user= adminMapper.userSelect(map);	
		
		resultMap.put("user",user);
		resultMap.put("result","success");
		return resultMap;
	}
	
	@Transactional
	public HashMap<String, Object> UpdateUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int cnt= adminMapper.userUpdate(map);
			int cnt2=adminMapper.sellerRoleUpdate(map);
		        if (cnt > 0 && cnt2 > 0) {
		            resultMap.put("result", "success");
		        } else if (cnt > 0) {
		            resultMap.put("result", "fail");
		        } else {
		            resultMap.put("result", "fail");
		        }
		        
		    } catch (Exception e) {
		        resultMap.put("result", "fail");
		        System.out.println(e.getMessage());
		    }
		    
		    return resultMap;
	}
	
	
	//구매자 상세
	public HashMap<String, Object> SelectOrder(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		List orderList= adminMapper.orderListSelect(map);
		int totalRows=adminMapper.orderCount(map);
		
		resultMap.put("orderList",orderList);
		resultMap.put("totalRows",totalRows);
		resultMap.put("result","success");
		return resultMap;
	}
	
	
			
	
	
	//2.판매자 관리
	
		public HashMap<String, Object> SelectSellerList(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			//sllerlist 
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				List <Admin> sellerList= adminMapper.sellerListSelect(map);
				resultMap.put("sellerList",sellerList);
				int totalRows=adminMapper.sellerCount(map);
				resultMap.put("totalRows",totalRows);
				resultMap.put("result","success");
			}catch(Exception e) {
				resultMap.put("result","fail");
				System.out.println(e.getMessage());		
			}	
			 return resultMap;
					
		}
		
		public HashMap<String, Object> DeleteSellerList(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			int cnt=adminMapper.sellerListDelete(map);
			resultMap.put("result","success");
			return resultMap;
		}
		
		public HashMap<String, Object> SelectSeller(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
			Admin seller= adminMapper.sellerSelect(map);	
			
			resultMap.put("seller",seller);
			resultMap.put("result","success");
			return resultMap;
		}
		
		// 입점신청자 (판매자) 업데이트
		@Transactional
		public HashMap<String, Object> UpdateSeller(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			int cnt= adminMapper.sellerUpdate(map);
			int cnt2=adminMapper.userRoleUpdate(map);
			resultMap.put("result","success");
			return resultMap;
		}
		
		//판매자 매출 상세
		public HashMap<String, Object> SelectSales(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				List <HashMap> list= adminMapper.salesSelect(map);
				List <Admin> productList= adminMapper.sellerPopularListSelect(map);
				resultMap.put("list",list);
				resultMap.put("productList",productList);
				resultMap.put("result","success");
			}catch(Exception e) {
				resultMap.put("result","fail");
				System.out.println(e.getMessage());		
			}	
			 return resultMap;
					
		}
		
		
		
		
		//3.membership
		public HashMap<String, Object> SelectMembershipList(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			//membershiplist 
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				List <Admin> membershipList= adminMapper.membershipListSelect(map);
				resultMap.put("membershipList",membershipList);
				int totalRows=adminMapper.membershipCount(map);
				resultMap.put("totalRows",totalRows);
				resultMap.put("result","success");
			}catch(Exception e) {
				resultMap.put("result","fail");
				System.out.println(e.getMessage());		
			}	
			 return resultMap;
					
		}
		
		//4.매출관리
		public HashMap<String, Object> SelectSalesTrends(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				List <HashMap> list= adminMapper.salesTrendsSelect(map);
				resultMap.put("list",list);
				resultMap.put("result","success");
			}catch(Exception e) {
				resultMap.put("result","fail");
				System.out.println(e.getMessage());		
			}	
			 return resultMap;
					
		}
		
		//5.QnA & review
		public HashMap<String, Object> SelectQnAList(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			//qnAlist 
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				List <Admin> qnAList= adminMapper.qnAListSelect(map);
				resultMap.put("qnAList",qnAList);
				int totalRows=adminMapper.qnACount(map);
				resultMap.put("totalRows",totalRows);
				resultMap.put("result","success");
			}catch(Exception e) {
				resultMap.put("result","fail");
				System.out.println(e.getMessage());		
			}	
			 return resultMap;
					
		}
		
		public HashMap<String, Object> SelectReviewList(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			//reviewlist 
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				List <Admin> reviewList= adminMapper.reviewListSelect(map);
				resultMap.put("reviewList",reviewList);
				int totalRows=adminMapper.reviewCount(map);
				resultMap.put("totalRows",totalRows);
				resultMap.put("result","success");
			}catch(Exception e) {
				resultMap.put("result","fail");
				System.out.println(e.getMessage());		
			}	
			 return resultMap;
					
		}
		
		public HashMap<String, Object> DeleteQnAList(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			int cnt=adminMapper.qnAListDelete(map);
			resultMap.put("result","success");
			return resultMap;
		}
		
		public HashMap<String, Object> DeleteReviewList(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			int cnt=adminMapper.reviewListDelete(map);
			resultMap.put("result","success");
			return resultMap;
		}
		
		
		//광고
		public HashMap<String, Object> SelectAdList(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			//adlist 
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				List <Admin> adList= adminMapper.adListSelect(map);
				resultMap.put("adList",adList);
				int totalRows=adminMapper.adCount(map);
				resultMap.put("totalRows",totalRows);
				resultMap.put("result","success");
			}catch(Exception e) {
				resultMap.put("result","fail");
				System.out.println(e.getMessage());		
			}	
			 return resultMap;
					
		}
		
		public HashMap<String, Object> CheckAd(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				int ad=adminMapper.adCheck(map);
				resultMap.put("result","success");
				resultMap.put("check", ad);
			}catch(Exception e) {
				resultMap.put("result","fail");
				System.out.println(e.getMessage());		
			}	
			 return resultMap;
					
		}
		public HashMap<String, Object> AddAd(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			int cnt= adminMapper.adAdd(map);
			resultMap.put("result","success");
			return resultMap;
		}
		
		public void InsertAdImg(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			int cnt= adminMapper.adImgInsert(map);
		}
		
		public HashMap<String, Object> SelectAd(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
			Admin ad= adminMapper.adSelect(map);	
			
			resultMap.put("ad",ad);
			resultMap.put("result","success");
			return resultMap;
		}
		
		public HashMap<String, Object> UpdateAd(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			int cnt= adminMapper.adUpdate(map);
			resultMap.put("result","success");
			return resultMap;
		}
		
	//자동 광고 정산
		
		public HashMap<String, Object> InsertandUpdateAdHistroy() {
		    HashMap<String, Object> resultMap = new HashMap<>();
		    try {
		        System.out.println("달말 광고료 정산을 시작하겠습니다.");
		        int cnt1=adminMapper.monthlyAdHistroyInsert ();
				int cnt2=adminMapper.monthlyAdHistroyUpdate ();
		        resultMap.put("result", "success");
		    } catch (Exception e) {
		        resultMap.put("result", "fail");
		        e.printStackTrace();
		    }
		    return resultMap;
		}

	    // 달말 마다 23:59 에 정산
//		@Scheduled(cron = "0 */5 * * * ?")
		@Component
		public class MonthlyAdScheduler {

		    @Autowired
		    private AdminService adminService;
		    
		    @Transactional
		    @Scheduled(cron = "0 59 23 L * ?")
//		    @Scheduled(cron = "0 * * * * ?")
		    public void executeMonthlyAd() {
		        adminService.InsertandUpdateAdHistroy();
		    }
		}
		
		
		
		
		
		//자동 수수료 정산
		
		public HashMap<String, Object> UpdateMonthlyFee() {
		    HashMap<String, Object> resultMap = new HashMap<>();
		    try {
		        System.out.println("달말 수수료 정산을 시작하겠습니다.");
		        int cnt = adminMapper.monthlyFeeUpdate();
//		        int cnt2=adminMapper.monthlyGradeUpdate();
		        System.out.println("test " + cnt);
		        resultMap.put("result", "success");
		    } catch (Exception e) {
		        resultMap.put("result", "fail");
		        e.printStackTrace();
		    }
		    return resultMap;
		}

	    // 달말 마다 23:59 에 정
//		@Scheduled(cron = "0 */5 * * * ?")
		@Component
		public class MonthlyFeeScheduler {

		    @Autowired
		    private AdminService adminService;
		    
		    @Transactional
		    @Scheduled(cron = "0 59 23 L * ?")
//		    @Scheduled(cron = "0 * * * * ?")
		    public void executeMonthlyFee() {
		        adminService.UpdateMonthlyFee();
		    }
		}
		
		
		
		//수익
		public HashMap<String, Object> SelectRevenue(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
			Admin revenue= adminMapper.revenueSelect(map);	
			
			resultMap.put("revenue",revenue);
			resultMap.put("result","success");
			return resultMap;
		}
	  
		
		// 월별 광고 수익 조회
		public HashMap<String, Object> SelectRevenueByMonth(HashMap<String, Object> map) {
		    HashMap<String, Object> resultMap = new HashMap<>();
		    try {
		        List<HashMap> list = adminMapper.revenueByMonthSelect(map);
		        resultMap.put("list", list);
		        resultMap.put("result", "success");
		    } catch (Exception e) {
		        resultMap.put("result", "fail");
		        System.out.println(e.getMessage());
		    }
		    return resultMap;
		}
		
		
		public HashMap<String, Object> SelectMonthlyFeeList(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			//adlist 
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				List <Admin> sellerList= adminMapper.monthlyFeeCalculate(map);
				resultMap.put("sellerList",sellerList);
				int totalRows=adminMapper.sellerCount(map);
				resultMap.put("totalRows",totalRows);
				resultMap.put("result","success");
			}catch(Exception e) {
				resultMap.put("result","fail");
				System.out.println(e.getMessage());		
			}	
			 return resultMap;
					
		}
		
		
		
		
	
	

}
