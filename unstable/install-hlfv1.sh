(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� P�'Y �]Ys⺶����y�����U]u�	�`c�֭�g&cc~�1��3t҉w�j�� 	Yַ֒��$�t���+7^���K��i�xEiyx��_(��(��V�Cq�����_Ӝ��dk;���Z��v��\��)�G�O|?�������4^f�2".�?Ed%�2��oS�_�C��_�-�����叒]ɿ\(����⊽w4\.��9�%���}��S���p��I��*���k���N�;�����q0Ew�~z-�=�h, (J�����<��8^�V��)>g���b�"��y8eS.a�4M�4�:$a��"�#��>M��ڎG�.�">��d_5�*��2������I���ǋ�Ր2:���WGpbCVk"/�A���&0�Z[�Ny��ty���,#�.��&���[�j��Z��P6m-hS���Zv�)�� n����W�،���@O+16)=�;�|<7�}��QQ��:�=��񔥇��VB�F��� �f�OX�z_^Ⱥ,R�B�#[��������Щ��*���tG�����o{�t����u��r��*~*��|���2��o�?zp�7�?J��S�O ��/�?/�,�|�6o5�,�M���A.s �5e)�ɬ�m�!ǳ�Rܶ���\�&�Y��i�q��e9�k�`jZC�[�� Jq#�D�S�&e�p�u#2�q�p�)��)� �6�8�C֐��#u�D]���Ev����A܉�q�jr@1�&��Z=7rw
G� �qEPr�x=X�b�#���4y���rK;
��[0Qx�Tv��й������i,"om졸�f`p�s�,�\Í���-�ܷ
�@��Y����_1��㡹7��R1���)n�M�'
�No

�8�WňP�<�9���n$�)a7�a/�-��bc���9}���)�h'�rVr�P����]i�Y&n��Vw�t3עf��)�8>�'�"�xy2�S4�E������5���'�K
P80y�(r�r�,��t�1)m�&Fv��Ê	��R=0�6H�\�h�D�i��&C!J !P�/k<y:9�����	t	#.b�fu0���n����ڹr�Iڒ�hj�x1��C&K f�ȱh�sfы��(�e��F�?=3��/��l���?��(^�)�$�?Jj����S���"������������u�����Nݯv�zK qO��|h��x,fȑ8N�
��Q/!T�g��~B>$��N=��"��U�TA������^���i�$��h�o``a���x6ad1Ok�K��w��Dѭ\������5$B}ٚ8������ˇ��B4�<6]�+�<s�y�i��}߁��{o��]~�-C��e[�*�ቪ{@k�(̶p-�#��4M93rր�6�����C�� �v~�d��Z.� ����>kr���r�Mwp�x/��-��))�D"�a�t�zr�a�:D��K}0�m�`B2���q���D���ϛX��X��P���o�m������}?��Z2��h�Y�!���:��x��_��������
T�_>E��9�}��G(����T���W���k���wL���O�8R��%�e�Oe���*�������O��$�^@�lqu�"���a��a���]sY��(?pQ2@1g=ҫ��)�!�7�����PU�e������qG��V�4��e��,��h\�o����b��Z6�`۶�17�ij��ɗ޲���f�V_r̹�4p�N�#ڃ967�hk�� ����V��(A��f)�Ӱ���(~i�e�O�_
>K����W��T���_��W��}H�e�O�������(�3�*���/�gz����C��!|��l����;�f���w�бY��G�Ǧ��|h ���N���p\�� ��I��!&��{SinM�	����0w�s��t��$��P�s��m6�7�y�ֻ� 
�4%
��<.&�R��;Y�c���'Zט#m�G��lp�H:����9:'�8���c� N��9`H΁ ҳm��-LC^���Νp�n��3Զ��$tpaA�ܠ�w�=Ο��={2hBU'���F�����z�_@�I���u���N�,�Ҳ��h�����j*8���1���Y��e�$d��9Ɋ�����O�K��+���������+�*�/��_�������������#�.�� �����%���_��������T�_���.���(��@�"�����%��16���ӏ:��O8C������빁���(���H��>��,IRv�����_���ERe�����T&��j�R��͉�1]0��cϑV�f?h�CO^��(���0�;uZI��!��h;��e>^�0�m�F9fl������#Bݞ��� ��|�q��g��Rrj��U�������~����(MT���������S�?��CU������2�p��q���)���$޾|Y9\.��J�e�3���vЋ口R��-����������O�����]��,F,�8�M��M��b��b������,����,��h�PTʐ���?8r<��Z��z\���Et�RKD�D�ń���6�F��w9W���i�~�~q�g5�	^�뺻�V��KQ=�#r�1v��2��-ptˇ`�Oe��4v��U뙈k���6H0{0��j��������v��U���w��P�xj�Q����������� ��h�
e���a���4��@���J�[�_�c����8��s Vrt��_c	K ��o����>��gI ���1v?n��AUZ.�wAU��72���A��>�a=:�;���@C��~شs�ā�ɧ>;�S�żx��ж�1��Mb�ڷ�M�	l#ע�iV��X�g�����z�N��7o�(6W3����V\4�ߛ��
�[g���|�G�-ãe�q�#=�$l��v�$�\h���@8ǻ5u�\�(R�&���t�*�)�sj�N%��ǆĭ�0����@ u�3"�mo�ey����A�Ě@�D0�ljN�����|sO���F���4�r�Yf<%���?m{�ȡ��<wJl���'�M�V������Z���"k�JC�y�`���_����+����?�W��?����?ɭ܀�e��M����O%���K�������� ���5��͝dv�
9���D�����P�'������7��6��w���>�#n�C�j
��k���m��W΃���ɡ���-*�;��5Y/��Z�o�JOM���C|k�r�Z��0�SٌI2��u��(�Z"��r��դ��y��!���܇.���� ��Y>h��@�Dk�<�w�u7��+e0��j.uq�?%s9��V{f��!Wk����=h�t�0B��G�P��a�?������/q����d�W
~��|�Q��)	_1����ʐ�G�����Y��_�j��Z�������w���s���aX�����r�_n�]���PU�g)��������\��-�(���O��o��r�'<¦iCI�b�d	��}�H�'p&@�vq�Q�!֧���u1�a0�:�B������/$]������ �eJ���-sjư���S�m�m+[,�Fi�5yq��1��t�V�֕�FwGѽdMq=�o{;�cF��sh}�
��A~
ӻ�N���r���)�2�Q_��,6��y����bw�����8���������G�����E���*[?�
-���7�7e~���~���\9^j�id����d������b:��N�+���c���B��k��^$������2��s%��UM�.�7<�iv�;�]���^�᧧&q��~��!�o�?�9�7��޷Z6�]�����Q;�w]�*R����t��޼���~,t�+���������jWN������o��]��N]�����G��%��}{�S���rmO�~z���bT���]ePQ��V�9O��1�n�]4��� �~�UQ����7D�.��ߑ��ϋ��׾�WD���e�VQI��d�;j���y�av}�(�΢г/7�˃��������ś7K���Q��l/V`t�7E�p�xV{����ǒ�LZ�����q��q��Z�������۫��ݮ�����{�*�~����{,��-��JcK����y�Χ��ƛ��jp���0N���R���ƹ.T�O��#��k���O4a���"D~��j��Ծ���}�������,n{�柫�S���X�"��wu�oY廂x#�D~`����݁�=Z �˪����N7��dS)���ʪ�}����0<��5��S8�,�%u�=��O��b������u���p�\υˡ��2f��{�t]�ҡ"]�n;]�ukO׵ۺ���;1AM�	&����?1�OJ�F��|P	4bD!&������l;g�p� �7��k��k����￿�yt��m��-=�d:c��lr�pSn%d"v���D2A�")<]F=�I#�L&���LG�a\��e�����I��,�L��p:�ǭ��7�r`��ѱ��b 6t/ͦ5 h��s�3�ڄ�r�ńq&v�E�Q�%I������v��k�&��u#��
�k�Cn��4�0�\t�Kq���3V3EL<�d�v[�t�ԵQ�w����|x�X/���P���vF���H�t[��i��-���K��v��;ĻY�3�h}0�׌+�E�=4��H�̪��5��˰Ѳ��f�����!�PZ����YF�W�VE��{�V�,/j���r4E>�h�C޷h�Ц�9
�.Mdé�G�S��b�p�~Gp:�0�Ӏٝ�#Z����� vr��"�A�;�ʢ޾sa�����1�I�Vc�6Ǻ���/dtI:�4`q���9�:�!���p�l���)U6^�5�}3��(�tn�~������G�JTx�Sk�Q�!��2i&qt��h>][��E�o�0�g�����!��a���|�X�.�"��UJ��A����5���5'Tku�?#4'3y9��~jϽ�}=���JF�U�t���(���sA�����\Et#ן��is0�1'�[G,dȌ��y	�5;]�A�^FLЌ�͉��x�F��N��ڹt|���os�X	����K���kQV��r�z!���9�ewgZ��T��U�1�p�i�ꍣ�����3`>��6���[e���Ǎ���~�A�����?��^���@a��Ʃ�����ϯv^k�ą�������� 6�"�^�_��Q7��ey4�z=۾jե�
���x8?�y8��zx�N�;t���kw���?\��Z�|��C�)~���]z�ϟ�^��3�-t�	
��\3�C?tB��	�n\z�΍�W�Ϝ��}z�����<���M���M�{��Ma��H֧�y����#rދ�\��r=����F/aL�5�	���xa��B�`h��o3�QX��W, �|��6rDr3o��X��;��%����������2\��4�S�{��Ks�|���z�&��a�2�|=8i�d3����3z3'�Ka�ȳ�Nw���)%�
G{����4�����b=�DY|"�H��[�(�2�젯d����"R��ճ�%���(W���������\
Jj��жJ�*S,����RS
��z���`���z��̈́���6v&,���2��a�S�z�km�	����-5C��֞�+!�V5���֢隒��� ��U�O2Ii�M��\=.�}-�x��&��\�D�����	�w$�3a2�p��	�CYIf�a�H�����P;�a���O�sȺGxFv�`Y�Nd&h?�U�C��Z-+�]����O�"M�i^�Ɓ�a�4W�4��g���f"X���!�h�����Ϗ1�}��|��%|Lʲd�e�rg6s�)��Rܷé���;���4�
H��#Т��Z�p>�!��,��WB�0VL��&,�)��VZ��++�*hnS�S���V��.����i����LKJ�)��٥�U=x�W�iߐ$�.�[V�4�]�HT�z��&-∩,�a����D��B�*����H�ɔ�B5���b��*.���[�,����_Y�+(K��x�B�
�GI��g�����&���j��v��~%��-�0԰�ƕhQ��ɵ�J�����#1��&��pNY�b�&�܋������r�3e�A�e����ReaB��w��������PR���t��5�r�l�M�}� �o6$u�G$�ZS�ڄ��y
u�P�d�"[� ��ۓ,v�~��}6�g�}��|��S��Ӝ(����ڼ�A�έ]	m@k�)�+6�@�M�J[�<`|]����Si֡3�i֯�.*ͳ�C�q�.ȶ9��˝6t#t���u55K�np�Py�sPJ�j� �	�܀s��qI]ܸ�D�b
i^k�5��Mu=�_�[ZG�Z�N���,ɖ�\k�&S�����5�����!g~�a5�iu�Y���U��^?a�\ 7
`��j���-���������6Kf|aZf���=w��E�Q�Ϝ�^����釞�6]�ŉ�j|<� 't p�I_�?9Gֿ�:�G���ס�֡����g��/+�<~��=Zx0i-<H�HB�g*]�$�V������-<(��:"m����`8;4�E�A�΃�"Xu��Ҟ'�8ꂃ�Z�Ә�֔A�{b��0c	>nzh��;CjSj�W����R��2�p���%�!ъ#��P� 9��
�"Bpd�)�Ѽ��&�tR�J�zq�и�T���*u<F�	�=�#A!m���11���!�GM���c���ajt����D�;X�Uo%���r$ӈu����|~g�P�T�~e�m)�(�l؃�`����o�ol�m�v|��ń`KT�H
Q��k�f��I��[g���K5��K�xx_�p��a�m���]/�n�6ݩ�eʹ<m�Cc�d:��gZ1byv�@w肷N%�:m%��y'��@˽����st�����a�/��eG�>8��U��Tp�m�$Rn�*�d�u���92P�x�#���*��r���A|&(2����E&����t��,�?=�.�f�!��T��Rv�b�J�`$�����8��
 LxG�p0%�e�	 ^V�$�i����e�;}_N�RBńp�0�����B�Bw;�l��aB�Ɩ�|;����JQ�u%
�6��J]��3�W,�mwD�Q�~�+�*x�����0₳L��٨f�A��lɅ���;<���-	�s.�n�$���\���&qW�^"�}�v^�ò��6��7�8��㞍��䔹�ͤX!��RHn�0��Ep���m6�jb�%d�j�kwT3Z����aJ|}��+��4^�{�p���?�Ǚ� �M���S�(����; �R��=G5��?���	�
�ͽ,f׫���ͭ�w|�_��KO=������_��е�~ ��U���5��>f��Տ�����w���ra6��2���x��?��A������/@7�~ ~�߼�/>���ȟ�?	}/����āܺv���k�2���ۼ6�NT�@��7⟿�{拍�I7�����˿��o|�I�u
�FA��?MQ;_pBo�R;_���6�Ӧv�4�&`S;�������v@�H��N��iS;m�������C�-/#��!H���@��,a�f��	��k�m�����@=�x�1C'}�~���צ�	/B6��v�l���)���j�l㰍�=��#y��� 3X��kS�l�yZ��;�jϙ�����93�q��q��a����\��9�;w��ڪ��w�<z�d���Z������������_��V�  