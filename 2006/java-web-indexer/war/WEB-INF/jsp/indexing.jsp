<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ include file="/WEB-INF/jsp/include.jsp"%>
<%@ include file="/WEB-INF/jsp/header.jsp"%>

<h1>Indekseerimine</h1>
<h2>Praegune kaust: <c:out value="${indexingBean.directory.absolutePath}"/></h2>
<display:table name="indexingBean.files" class="InfoTable" pagesize="30" requestURI="indexing.htm">
	<display:column property="name" title="Faili/kausta nimi" sortable="true" href="indexing.htm" paramId="dirname" paramProperty="absolutePath"/>
	<display:column title="Indekseerimine" sortable="true" href="indexDirectory.htm" paramId="dirname" paramProperty="absolutePath">Indekseeri</display:column>
</display:table>

<%@ include file="/WEB-INF/jsp/footer.jsp"%>
