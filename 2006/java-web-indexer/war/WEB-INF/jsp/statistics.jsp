<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ include file="/WEB-INF/jsp/include.jsp"%>
<%@ include file="/WEB-INF/jsp/header.jsp"%>

<h1>Statistika</h1>

<ul>
	<li>Sõnade arv: <c:out value="${wordCount}"/></li>
	<li>Failide arv: <c:out value="${fileCount}"/></li>
</ul>

<%@ include file="/WEB-INF/jsp/footer.jsp"%>
