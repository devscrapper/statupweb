#function hash(d){
#    var a=1,c=0,h,o;
#    if(d){
#        a=0;
#        for(h=d["length"]-1;h>=0;h--){
#            o=d.charCodeAt(h);
#            a=(a<<6&268435455)+o+(o<<14);
#            c=a&266338304;
#            a=c!=0?a^c>>21:a
#        }
#    }
#    return a
#}


    def hashdomain(d)
      a = 0
      c = 0
      d.split(//).reverse_each{|h|
        o = h.ord
        a=(a<<6&268435455)+o+(o<<14);
                    c=a&266338304;
                    a=c!=0?a^c>>21:a
      }
      a

end
      a = "a"
    p a.ord
p hashdomain("w3schools.com")