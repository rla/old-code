package ee.pri.rl.indexer.indexing.configuration;

public interface Configuration {

	/**
	 * Tagastusmeetod seadistuse lugemiseks.
	 */
	public boolean isSkipCommonWords();

	/**
	 * Tagastusmeetod seadistuse lugemiseks.
	 */
	public boolean isIndexBasic();

	/**
	 * Tagastusmeetod seadistuse lugemiseks.
	 */
	public boolean isIndexCSource();

	/**
	 * Tagastusmeetod seadistuse lugemiseks.
	 */
	public boolean isIndexPascal();

	/**
	 * Tagastusmeetod seadistuse lugemiseks.
	 */
	public boolean isIndexText();

	/**
	 * Tagastusmeetod seadistuse lugemiseks.
	 */
	public boolean isIndexXML();

	/**
	 * Ajutiste failide kausta asukoha saamine.
	 */
	public String getTemporaryDirectory();

	/**
	 * Siin on määratud, millised failid loetakse tekstifailideks, määramine
	 * toimub faililaiendi põhjal.
	 */
	public boolean isTxt(String extension);
	
	/**
	 * Siin on määratud, millised failid loetakse PDF failideks, määramine
	 * toimub faililaiendi põhjal.
	 */
	public boolean isPdf(String extension);

	/**
	 * Siin on määratud, millised failid loetakse C sarnase süntaksiga
	 * programmeerimiskeele lähtekoodifailideks.
	 */
	public boolean isCSource(String extension);

	/**
	 * Siin on määratud, millised failid loetakse XML koodiks.
	 */
	public boolean isXML(String extension);

	/**
	 * Siin on määratud, millised failid loetakse Pascal tüüpi
	 * programmeerimiskeele lähtekoodifailideks.
	 */
	public boolean isPascalSource(String extension);

	/**
	 * Siin on määratud, millised failid loetakse Basic tüüpi
	 * programmeerimiskeele lähtekoodifailideks.
	 */
	public boolean isBasicSource(String extension);
	
	/**
	 * Siin on määratud, kas indekseeritavate failide laienditele
	 * mittevastavate failide nimed pannakse andmebaasi.
	 */
	public boolean isSaveAllFileNames();

}