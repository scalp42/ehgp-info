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
      ', "sp_Telefon" as telefon',
      ', "sp_Fax" as fax',
      ', "sp_Mail" as mail',
      ', "sp_Strasse" as strasse',
      ', "sp_HausNummer" as hausnummer',
      ', "sp_Plz" as plz',
      ', "sp_Ort" as ort',
      ', "sp_Kanton" as kanton',
      ', "im_Name" as intermediaer',
      ', "sp_Typ" as typ',
      ', "sp_Sprache" as sprache',
      ', "sp_cd_LeXmlZertifiziert" as xml_zertifiziert',
      ', "sp_XmlOhneStorno" as xml_ohne_storno',
      'from "StammSpital"',
      'left join "Intermediaer" on "im_ID" = "sp_Intermediaer"',
      'where "sp_Aktiv" < 50'
  end

  def self.top_le(from, to)
    select '"Mandant"."md_Beschreibung" as kanton',
      ', "PersonFirma"."pe_Name" as le',
      ', count("KoGu"."kg_ID") as anzahl',
      'from "Mandant"',
      'inner join "KoGu" on "KoGu"."kg_md_ID" = "Mandant"."md_ID"',
      'inner join "PersonFirma" on "PersonFirma"."pe_kg_ID" = "KoGu"."kg_ID"',
      'where "Mandant"."md_ID" < 50',
      'and "PersonFirma"."pe_Typ" = 7',
      %Q{and "KoGu"."kg_CreateDate" >= to_Date('#{from}', 'YYYY-MM-DD') -- von},
      %Q{and "KoGu"."kg_CreateDate" <= to_Date('#{to}', 'YYYY-MM-DD') -- bis},
      %q{and "KoGu"."kg_ReferenzNr" not like 'S%'},
      'group by "Mandant"."md_Beschreibung", "PersonFirma"."pe_Name"',
      'order by "Mandant"."md_Beschreibung" asc, count("KoGu"."kg_ID") DESC'
  end
end
