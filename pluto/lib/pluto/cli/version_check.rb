#####
#  simple version check
#      used version MUST always be greater or equal than minimum requirement

def version_check( *versions )
 
    outdated = []   ## list of outdated entries

    versions.each do |rec|
        name         = rec[0]
        ##  convert "2.0.17" to  [2,0,17] or
        ##          "2.1"    to  [2,1]     
        ## note: use Integer and NOT to_i; will through exception if version is not a number
        min_version  = rec[1].split( '.' ).map { |part| Integer(part) }
        used_version = rec[2].split( '.' ).map { |part| Integer(part) }

        ## check for minimum version requirement 
        min_version.zip( used_version ) do |part|
            min_num  = part[0]
            used_num = part[1] || 0    ## support unlikley edge case (used_version has less version parts than min_version)
            if used_num > min_num 
                ## used version is greater; stop comparing 
                break   
            elsif used_num == min_num
                ## continue compare with next version number part
                next  
            else
                ## used version is smaller; add and report outdated (!!) entry; stop comparing  
                outdated << rec
                break
            end
        end
    end

    outdated
end

