require 'models/base'

class Statistik
  extend DatabaseHelpers

  def self.efakturas
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
end
