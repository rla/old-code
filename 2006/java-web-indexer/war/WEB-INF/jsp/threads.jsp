<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ include file="/WEB-INF/jsp/include.jsp"%>
<%@ include file="/WEB-INF/jsp/header.jsp"%>

<h1>Lõimed</h1>
<display:table name="threads" class="InfoTable" pagesize="30" requestURI="/threads.htm">
	<display:column property="description" title="Lõime kirjeldus" sortable="true" />
	<display:column property="currentTask" title="Hetke tegevus" sortable="true" />
	<display:column property="startTime" title="Käivitusaeg" sortable="true" />
	<display:column property="workTime" title="Tööaeg" sortable="true" />
</display:table>

<%@ include file="/WEB-INF/jsp/footer.jsp"%>
