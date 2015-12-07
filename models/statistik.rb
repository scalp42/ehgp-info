require 'models/base'

class Statistik
  extend DatabaseHelpers

  def self.efaktura
    select 'extract(year from r."rg_eingang") as jahr',
      ', extract(month from r."rg_eingang") as monat',
      ', m."md_Kanton" as kanton',
      ', count(*) as rechnungen',
      'from KOGU."Rechnung" r',
      'join KOGU."KoGu" k on k."kg_ID" = r."rg_fk_kg_ID"',
      'join KOGU."Mandant" m on m."md_ID" = k."kg_md_ID"',
      'where "rg_erfasser" = \'XML Faktura\'',
      'group by extract(year from r."rg_eingang")',
      '    , extract(month from r."rg_eingang")',
      '    , m."md_Kanton"',
      'order by jahr asc, monat asc'
  end

  def self.aktive_le
    select '"sp_ID" as id',
      ', "sp_Name" as name',
      ', "sp_EAN" as ean',
      %q{, nvl("GruppenID", 'Nutzt eKOGU nicht') as guppen_id},
      ', "sp_Telefon" as telefon',
      ', "sp_Fax" as fax',
      ', "sp_Mail" as mail',
      ', "sp_Strasse" as strasse',
      ', "sp_HausNummer" as hausnummer',
      ', "sp_Plz" as plz',
      ', "sp_Ort" as ort',
      ', "sp_Kanton" as kanton',
      ', "sp_Typ" as typ',
      ', "sp_Sprache" as sprache',
      ', "sp_cd_LeXmlZertifiziert" as xml_zertifiziert',
      ', "sp_XmlOhneStorno" as xml_ohne_storno',
      'from KOGU."StammSpital"',
      %(left join KOGU."IS_Gruppe" on "Referenz" = "sp_ID" and "ReferenzTyp" = 'LE'),
      'where "sp_Aktiv" < 50'
  end
end
