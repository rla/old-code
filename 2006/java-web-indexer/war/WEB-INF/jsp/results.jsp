<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ include file="/WEB-INF/jsp/include.jsp"%>
<%@ include file="/WEB-INF/jsp/header.jsp"%>

<h1>Otsingu tulemused</h1>
<h2>Otsisõne: "<c:out value="${search.searchString}" />", aega läks: <c:out value="${search.time}" />ms</h2>
<display:table name="search.files" class="InfoTable" pagesize="30" requestURI="/search.htm">
	<display:column property="name" title="Faili nimi" sortable="true" />
</display:table>

<%@ include file="/WEB-INF/jsp/footer.jsp"%>
