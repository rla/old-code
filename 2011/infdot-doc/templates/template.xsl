<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exslt="http://exslt.org/common"
	xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml">

	<xsl:output method="xml" encoding="UTF-8"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />

	<!-- the identity template -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<!-- template for the head section. Only needed if we want to change, delete 
		or add nodes. In our case we need it to add a link element pointing to an 
		external CSS stylesheet. -->

	<xsl:template match="xhtml:head">
		<xsl:copy>
			<link rel="stylesheet" href="ascetic.css" type="text/css" />
			<script type="text/javascript" src="highlight.pack.js" />
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="xhtml:head/xhtml:title">
		<xsl:copy>
			<xsl:value-of select="/xhtml:html/xhtml:body/xhtml:h1/text()[1]" />
		</xsl:copy>
	</xsl:template>

	<!-- template for the body section. Only needed if we want to change, delete 
		or add nodes. In our case we need it to add a div element containing a menu 
		of navigation. -->

	<xsl:template match="xhtml:body">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
			<script type="text/javascript">
				hljs.initHighlightingOnLoad();
			</script>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
