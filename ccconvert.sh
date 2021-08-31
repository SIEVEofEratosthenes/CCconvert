#!/bin/bash

APIKEY="YOUR_API_KEY"
FCOIN=""
TCOIN=""
AMT=""
USD=0

help_screen() {
        echo " " 
        echo "CCconvert v0.314 (Donald Ewen Cameron)"
        echo " "
        echo "Usage: "
        echo " "
        echo "$0 -a <amount> -f <from_coin> -t <to_coin> [options]"
        echo " "
        echo "Options:  "
        echo "             -a|--amount     <amount>"
        echo "             -f|--from       <coin>"
        echo "             -t|--to         <coin>"
        echo "             -u|--usd,       Get USD price of converted coin also"
        echo "             -h|--help,      this help screen      "
        echo " "
        echo "Example: "
        echo "         $0 -a 30 -f ADA -t XMR"
        echo "         $0 -a 100 -f USD -t BTC"
        echo " "
        exit
        
}

convert_crypto() { 
        API="https://min-api.cryptocompare.com/data/price?fsym=${FCOIN}&tsyms=${TCOIN}&api_key=$APIKEY"
        RESULT=`curl -s "$API"`
        toAMT=`echo $RESULT | cut -d ":" -f 2 | sed -e 's/\}//g'`
        if [[ "$TCOIN" == "USD" ]]; then
               convAMT=`echo "scale=2; (($AMT*$toAMT)*100)/100" | bc`
        else 
               convAMT=`echo "scale=12; $AMT*$toAMT" | bc`
        fi
        echo " "
        if [[ $USD -eq 1 ]]; then
                APIUSD="https://min-api.cryptocompare.com/data/price?fsym=${TCOIN}&tsyms=USD&api_key=$APIKEY"
                USDRESULT=`curl -s "$APIUSD"`
                usdAMT=`echo $USDRESULT | cut -d ":" -f 2 | sed -e 's/\}//g'`
                USDconvAMT=`echo "scale=2; (($usdAMT*$convAMT)*100)/100" | bc`
                echo "$AMT $FCOIN ---> $convAMT $TCOIN ---> $USDconvAMT USD"
                echo " "                
        else
                echo "$AMT $FCOIN ---> $convAMT $TCOIN"
                echo " "        
        fi
        

}


while [ "$#" -gt 0 ]; do
        key=${1}

        case ${key} in
                -f|--from)
                        FCOIN=${2^^}
                        shift
                        shift
                        ;;
		-t|--to)
                        TCOIN=${2^^}
                        shift
                        shift
                        ;;
                -a|--amount)
                        AMT=${2}
                        shift
                        shift
                        ;;
                -u|--usd)
                        USD=1
                        shift
                        ;;
                				
                        
                -h|--help)
                        help_screen
                        shift
                        ;;
                				
                *)
                        shift
                        ;;
        esac
done

if [[ -z $FCOIN ]] || [[ -z $TCOIN ]] || [[ -z $AMT ]]; then
        help_screen

else
        convert_crypto
fi








