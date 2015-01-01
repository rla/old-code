<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/include.jsp"%>
<%@ include file="/WEB-INF/jsp/header.jsp"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<h1>Otsing</h1>

<form name="search" action="search.htm" method="post">
	<input type="text" maxlength="200" name="searchString" />
	<select name="type">
		<option value="1">Faili sisust</option>
		<option value="2">Faili nimest</option>
	</select>
	<input class="button" type="submit" value="Otsi" />
</form>

<%@ include file="/WEB-INF/jsp/footer.jsp"%>

