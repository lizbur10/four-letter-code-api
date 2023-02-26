# https://itnext.io/how-to-seed-a-rails-database-with-a-csv-file-105a7ba0e88c

require 'csv'

## See models/utility.rb for documentation on these files

aba_filename = File.join(Rails.root, 'app', 'csv', 'ABA_Checklist-8.11b.csv')
ebird_filename = File.join(Rails.root, 'app', 'csv', 'eBird_Taxonomy_v2022.csv')

# Step 1
CSV.foreach(aba_filename, headers: true) do |row|
    if (row["common_name"])
        Bird.create(row.to_hash)
    end
end

# Step 2
CSV.foreach(ebird_filename, headers: true) do |row|
    if found_bird = Bird.all.find_by(sci_name: row["sci_name"]) || Bird.all.find_by(common_name: row["primary_com_name"]) 
        found_bird.taxon_order = row["taxon_order"].to_i
        found_bird.ebird_species_code = row["species_code"]
        found_bird.save
    end
end

#Step 3
appledore_birds = ["ACFL", "ALFL", "AMGO", "AMRE", "AMRO", "BAOR", "BARS", "BAWW", "BBCU", "BBWA", "BCCH", "BEKI", "BGGN", "BHCO", "BHVI", "BITH", "BLBW", "BLGR", "BLJA", "BLPW", "BOBO", "BRCR", "BRTH", "BRWA", "BTBW", "BTNW", "BWHA", "BWWA", "CARW", "CAWA", "CCSP", "CEDW", "CERW", "CHSP", "CMWA", "COGR", "CONW", "COYE", "CSWA", "CWWI", "DICK", "DOWO", "EAKI", "EAPH", "EATO", "EAWP", "EUST", "EVGR", "EWPW", "FISP", "FOSP", "GCBT", "GCFL", "GCKI", "GCTH", "GRCA", "GRSP", "GWWA", "HAWO", "HERG", "HETH", "HOFI", "HOWA", "HOWR", "INBU", "KEWA", "LASP", "LAWA", "LEBI", "LEFL", "LESA", "LISP", "LOWA", "MALL", "MAWA", "MAWR", "MERL", "MODO", "MOWA", "MYWA", "NAWA", "NESP", "NOCA", "NOHA", "NOMO", "NOPA", "NOWA", "NSWO", "OCWA", "OROR", "OSFL", "OVEN", "PABU", "PHVI", "PISI", "PIWA", "PRAW", "PROW", "PUFI", "RBGR", "RBNU", "RBWO", "RCKI", "REVI", "RTHU", "RUBL", "RWBL", "SAVS", "SCJU", "SCTA", "SEPL", "SESP", "SORA", "SOSA", "SOSP", "SPSA", "SSHA", "SUTA", "SWSP", "SWTH", "TEWA", "TRES", "TRFL", "VEER", "WAVI", "WBNU", "WCSP", "WEKI", "WEVI", "WEWA", "WIWA", "WIWR", "WOTH", "WPWA", "WTSP", "YBCH", "YBCU", "YBFL", "YBSA", "YEWA", "YPWA", "YSFL", "YTVI", "YTWA"]
appledore_birds.each do |bird_code|
    if found_bird = Bird.all.find_by(four_letter_code: bird_code)
        found_bird.appledore = true
        found_bird.save
    end
end

# After seeding, run `Utility.check_for_missing_birds` to check for four-letter codes
# in the appledore_birds array that have changed
# Fix `appledore_birds`` array as needed, then rerun Steps 2 & 3 (NOT 1)
