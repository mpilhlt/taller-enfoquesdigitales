<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- a small (and very simple) program for finding place names pre-defined in
        a gazetteer within the tei:text body of a TEI document -->
    
    <xsl:output method="xml" indent="no" encoding="UTF-8"/>

<!-- Identity transform -->
    <xsl:template match="@*|node()" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
            
    <!-- open and parse the csv file containing place names -->
    <xsl:variable name="placesCSV" select="unparsed-text('lugares.csv', 'utf-8')"/>
    <xsl:variable name="placesEntries" select="tokenize($placesCSV, '\n')"/>
    <xsl:variable name="placesSorted" as="xs:string*">
        <xsl:for-each select="$placesEntries">
            <xsl:sort order="descending" select="string-length(tokenize(., ',')[1])"/>
            <xsl:value-of select="tokenize(., ',')[1]"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="places" 
        select="string-join($placesSorted, '|')"/>
    <xsl:variable name="placesXML">
        <places>
            <xsl:for-each select="$placesEntries">
                <place>
                    <name><xsl:value-of select="tokenize(., ',')[1]"/></name>
                    <ref><xsl:value-of select="tokenize(., ',')[2]"/></ref>
                    <key><xsl:value-of select="tokenize(., ',')[3]"/></key>
                </place>
            </xsl:for-each>
        </places>
        
    </xsl:variable>
  
  <!-- tagging place names: -->
    <xsl:template match="//tei:text//text()[not(ancestor::tei:note)]"> <!-- excluding marginal notes from NER tagging -->
        <xsl:analyze-string select="." regex="{$places}">
            <xsl:matching-substring>
                <xsl:variable name="place" select="."/>
                <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
                    <!-- if the CSV document contains a getty ID and normalized form of 
                    the name, include them here: -->
                    <xsl:if test="$placesXML//name[./text() eq $place and ./following-sibling::ref/text()]">
                        <xsl:attribute name="ref" 
                            select="concat('getty:', $placesXML//name[./text() eq $place][1]/following-sibling::ref/text())">
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$placesXML//name[./text() eq $place and ./following-sibling::key/text()]">
                        <xsl:attribute name="key" 
                            select="$placesXML//name[./text() eq $place][1]/following-sibling::key/text()">
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                 <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
</xsl:stylesheet>

