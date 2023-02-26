require 'csv'

class Utility < ApplicationRecord
    # https://stackoverflow.com/questions/4410794/ruby-on-rails-import-data-from-a-csv-file
    # https://stackoverflow.com/questions/41314784/getting-unknownattributeerror-in-rake-using-csv-attribute-exists-in-rails-app
    # Cleaned up spreadsheets to get rid of headers, blank lines, etc. then used Numbers app 
    # to export original spreadsheet to CSV - otherwise get `CSV::MalformedCSVError`

    # Ebird API link for possible future reference: https://documenter.getpostman.com/view/664302/S1ENwy59?version=latest#intro

    # Downloaded ABA checklist spreadsheet from this page: https://www.aba.org/aba-checklist/ (12/19 version)
    # Added BRWA, GCBT, LAWA, MYWA, SCJU, TRFL, WPWA, YPWA, YSFL by hand
    def self.read_aba_csv
        filename = File.join(Rails.root, 'app', 'csv', 'ABA_Checklist-8.11b.csv')
        CSV.foreach(filename, headers: true) do |row|
            if (row["common_name"])
                Bird.create(row.to_hash)
            end
        end
    end

    # Downloaded eBird taxonomy spreadsheet (v2019) from this page: https://www.birds.cornell.edu/clementschecklist/download/?__hstc=60209138.6f747e6e23a2f1b7014cf372ca892894.1544132358313.1566237656917.1566240564794.714&__hssc=60209138.3.1566240564794&__hsfp=2467889448
    def self.read_ebird_csv
        filename = File.join(Rails.root, 'app', 'csv', 'eBird_Taxonomy_v2022.csv')
        CSV.foreach(filename, headers: true) do |row|
            if found_bird = Bird.all.find_by(sci_name: row["sci_name"]) || Bird.all.find_by(common_name: row["primary_com_name"]) 
                found_bird.taxon_order = row["taxon_order"].to_i
                found_bird.ebird_species_code = row["species_code"]
                found_bird.save

            end
        end
    end

    # Species list taken from sml-band list, updated through spring '18
    def self.add_appledore_flag
        appledore_birds = ["ACFL", "ALFL", "AMGO", "AMRE", "AMRO", "BAOR", "BARS", "BAWW", "BBCU", "BBWA", "BCCH", "BEKI", "BGGN", "BHCO", "BHVI", "BITH", "BLBW", "BLGR", "BLJA", "BLPW", "BOBO", "BRCR", "BRTH", "BRWA", "BTBW", "BTNW", "BWHA", "BWWA", "CARW", "CAWA", "CCSP", "CEDW", "CERW", "CHSP", "CMWA", "COGR", "CONW", "COYE", "CSWA", "CWWI", "DICK", "DOWO", "EAKI", "EAPH", "EATO", "EAWP", "EUST", "EVGR", "EWPW", "FISP", "FOSP", "GCBT", "GCFL", "GCKI", "GCTH", "GRCA", "GRSP", "GWWA", "HAWO", "HERG", "HETH", "HOFI", "HOWA", "HOWR", "INBU", "KEWA", "LASP", "LAWA", "LEBI", "LEFL", "LESA", "LISP", "LOWA", "MALL", "MAWA", "MAWR", "MERL", "MODO", "MOWA", "MYWA", "NAWA", "NESP", "NOCA", "NOHA", "NOMO", "NOPA", "NOWA", "NSWO", "OCWA", "OROR", "OSFL", "OVEN", "PABU", "PHVI", "PISI", "PIWA", "PRAW", "PROW", "PUFI", "RBGR", "RBNU", "RBWO", "RCKI", "REVI", "RTHU", "RUBL", "RWBL", "SAVS", "SCJU", "SCTA", "SEPL", "SESP", "SORA", "SOSA", "SOSP", "SPSA", "SSHA", "SUTA", "SWSP", "SWTH", "TEWA", "TRES", "TRFL", "VEER", "WAVI", "WBNU", "WCSP", "WEKI", "WEVI", "WEWA", "WIWA", "WIWR", "WOTH", "WPWA", "WTSP", "YBCH", "YBCU", "YBFL", "YBSA", "YEWA", "YPWA", "YSFL", "YTVI", "YTWA"]
        appledore_birds.each do |bird_code|
            if found_bird = Bird.all.find_by(four_letter_code: bird_code)
                found_bird.appledore = true
                found_bird.save
            end
        end
    end

    def self.check_for_missing_birds
        lost_codes = []
        appledore_birds = ["ACFL", "ALFL", "AMGO", "AMRE", "AMRO", "BAOR", "BARS", "BAWW", "BBCU", "BBWA", "BCCH", "BEKI", "BGGN", "BHCO", "BHVI", "BITH", "BLBW", "BLGR", "BLJA", "BLPW", "BOBO", "BRCR", "BRTH", "BRWA", "BTBW", "BTNW", "BWHA", "BWWA", "CARW", "CAWA", "CCSP", "CEDW", "CERW", "CHSP", "CMWA", "COGR", "CONW", "COYE", "CSWA", "CWWI", "DICK", "DOWO", "EAKI", "EAPH", "EATO", "EAWP", "EUST", "EVGR", "EWPW", "FISP", "FOSP", "GCBT", "GCFL", "GCKI", "GCTH", "GRCA", "GRSP", "GWWA", "HAWO", "HERG", "HETH", "HOFI", "HOWA", "HOWR", "INBU", "KEWA", "LASP", "LAWA", "LEBI", "LEFL", "LESA", "LISP", "LOWA", "MALL", "MAWA", "MAWR", "MERL", "MODO", "MOWA", "MYWA", "NAWA", "NESP", "NOCA", "NOHA", "NOMO", "NOPA", "NOWA", "NSWO", "OCWA", "OROR", "OSFL", "OVEN", "PABU", "PHVI", "PISI", "PIWA", "PRAW", "PROW", "PUFI", "RBGR", "RBNU", "RBWO", "RCKI", "REVI", "RTHU", "RUBL", "RWBL", "SAVS", "SCJU", "SCTA", "SEPL", "SESP", "SORA", "SOSA", "SOSP", "SPSA", "SSHA", "SUTA", "SWSP", "SWTH", "TEWA", "TRES", "TRFL", "VEER", "WAVI", "WBNU", "WCSP", "WEKI", "WEVI", "WEWA", "WIWA", "WIWR", "WOTH", "WPWA", "WTSP", "YBCH", "YBCU", "YBFL", "YBSA", "YEWA", "YPWA", "YSFL", "YTVI", "YTWA"]
        appledore_birds.each do |bird_code|
            if !found_bird = Bird.all.find_by(four_letter_code: bird_code)
                lost_codes << bird_code
            end
        end
        lost_codes
    end
end