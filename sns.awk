# seven number summary

function indexcheck(size, value) {
    return (value > size) ? size : value;
}

BEGIN {
    c = 0; sum = 0;
}
            
/^[^#]/{
    a[c++] = $1; sum += $1;
}
            
END {
    mean = sum/c;    
    
    if ((c%2) == 1) {
        median = a[int(c/2)];
    } else {
        median = (a[c/2]+a[c/2-1])/2;
    }

    p2index  = indexcheck(int((c * 2  / 100) + 0.5), c -1 );
    p9index  = indexcheck(int((c * 9  / 100) + 0.5), c -1 );
    p25index = indexcheck(int((c * 25 / 100) + 0.5), c -1 );
    p75index = indexcheck(int((c * 75 / 100) + 0.5), c -1 );
    p91index = indexcheck(int((c * 91 / 100) + 0.5), c -1 );
    p98index = indexcheck(int((c * 98 / 100) + 0.5), c -1 );
    
    print \
        "{ \"count\":",c,
        ", \"mean\":",mean,
        ", \"p2\":",a[p2index],
        ", \"p9\":",a[p9index],
        ", \"p25\":",a[p25index],
        ", \"median\":",median,
        ", \"p75\":",a[p75index],
        ", \"p91\":",a[p91index],
        ", \"p98\":",a[p98index],
        ", \"min\":",a[0],
        ", \"max\":",a[c-1],
        "}"
}
