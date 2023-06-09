<%@ page contentType="text/html; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>


<html>
<head>


<title>
상품 목록조회
</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
function fncGetUserList(currentPage){
	$("#currentPage").val(currentPage)
	$("form").attr("method" , "POST").attr("action" , "/product/listProduct?menu=${param.menu}").submit();
}

$(function() { 
	$( "td.ct_btn01:contains('검색')" ).on("click" , function() {
		fncGetUserList(1);
	});
	
	$( ".ct_list_pop td:nth-child(5)" ).on("click" , function() {
		
		var a = $($(this).children());
	
		if(${param.menu=='manage'}){
		self.location ="/product/updateProduct?menu=${param.menu}&prodNo="+a[0].value;
		}else{
		self.location ="/product/getProduct?menu=${param.menu}&prodNo="+a[0].value; 
		}
		
	});

	/*
	$.ajax({
			url:"./images/uploadFiles",
			processDdata : false,
			contentType : false,
			data : formData,
			type : 'POST',
			dataType : 'json',
			success : function(result){
				showUploadedFile(result);
				$("#thumbnail").htmnl(cloneObj.html());
			}
		});*/
	


	
//$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
	$(  ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
	//Debug..
	//alert(  $( this ).text().trim() );
	
	//////////////////////////// 추가 , 변경된 부분 ///////////////////////////////////
	//self.location ="/user/getUser?userId="+$(this).text().trim();
	////////////////////////////////////////////////////////////////////////////////////////////
	var prodNo = $($(".ct_list_pop td:nth-child(5)").children());
	
	$.ajax( 
			{
				url : "/product/json/getProduct/"+prodNo[0].value ,
				method : "GET" ,
				dataType : "json" ,
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				success : function(JSONData , status) {

					//Debug...
					//alert(status);
					//Debug...
					//alert("JSONData : \n"+JSONData);
					
					var displayValue = "<h3>"
												+"상품번호 : "+JSONData.prodNo+"<br/>"
												+"상품이름 : "+JSONData.prodName+"<br/>"
												+"상품정보 : "+JSONData.prodDetail+"<br/>"
												+"상품정보 : "+JSONData.price+"<br/>"
												+"</h3>";
					//Debug...									
					//alert(displayValue);
					$("h3").remove();
					$( "#"+prodNo[0].value+"" ).html(displayValue);
				}
		});
		////////////////////////////////////////////////////////////////////////////////////////////
	
});


$( ".ct_list_pop td:nth-child(5)" ).css("color" , "red");

$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
});


</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">
<!--%search %-->
<form name="detailForm">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37">
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">
						${param.menu=='manage'?"상품관리":"상품검색"}
					</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37">
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>

		<td align="right">
			<select name="searchCondition" class="ct_input_g" style="width:80px">
				<option value="0"  ${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>상품번호</option>
				<option value="1"  ${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>상품명</option>
				<option value="2"  ${ ! empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>상품가격</option>
	
			</select>
			<input 	type="text" name="searchKeyword"  value="${! empty search.searchKeyword ? search.searchKeyword : ""}" 
							class="ct_input_g" style="width:200px; height:19px" >
		</td>
	
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						검색
					</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td colspan="11" >전체  ${resultPage.totalCount} 건수, 현재 ${resultPage.currentPage} 페이지</td>
		
	</tr>
	<tr>
		<td class="ct_list_b" width="100">이미지</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">등록일</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">현재상태</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	<c:set var="i" value="0" />
	<c:forEach var="product" items="${list}">
		<c:set var="i" value="${ i+1 }" />
		<tr class="ct_list_pop">
			<td><img src="../images/uploadFiles/s_${product.fileName.substring(0,product.fileName.indexOf("&")}"></td>
			<td></td>
			<td align="center">${i}</td>
			<td></td>
			<td align="left">
					${product.prodName} <input type="hidden" value="${product.prodNo}" class="prodNO"/>
			</td>
			<td></td>
			<td align="left">${product.price}</td>
			<td></td>
			<td align="left">${product.manuDate}</td>
			<td></td>
			<td align="left">재고없음</td>
		</tr>
		<tr>
			<td id="${product.prodNo}" colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>
	</c:forEach>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
			   <input type="hidden" id="currentPage" name="currentPage" value=""/>
					<jsp:include page="../common/pageNavigator.jsp"/>	
    	</td>
	</tr>
</table>
<!--  페이지 Navigator 끝 -->
</form>
</div>

</body>
</html>