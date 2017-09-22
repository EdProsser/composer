ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

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

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� m�Y �=�r�Hv��d3A�IJ��&��;ckl� �����*Z"%^$Y���&�$!�hR��[�����7�y�w���x/�%�3c��l�>};�n�>԰�DV@ŭ6�Q�m�^�®�{-����@ ���pL��S�B���"����G��" �S���h�ȱ`G���-{�+��l������ldut�����6�L���Md}0am���z�IY��F���:�B��c,�P��rl�$ �lK���g����f�� )y�?<(�K��L.�~� p5�D�W����6x;Y>|�BԠ	�l��O	A_��r��
d&���h-��T@�����T9�b�rTN�U#��\�v�.0�d�&2<ܹ��g>�Ϧ��0��I;�pM7��	6�ik5X�tu��5d���v��wG2�2�Aa�T�[눋��w���-�j��q(8dh�xYE��v��.]� ,�Ö�,�rK�x��i��A�^���v(�S��j��`;&D���N�?�)�B�؊�>��AтZ-��K�:V]̗᪋Ŗ���o8N��_�AL�N�_^&"��Q��͑F���i}-��E�sT�[fJ]�9�E�>��:��oJ1�ɼs;�2&b��t�^D�ϙ��b��슆j�5|�.d��ؒI�����>��|�i���:j�	������b�y����'K�Oe1"?�{�������� �F���נݸkl�#��_�$����,I�L�Ř,�������BU�U���l�Z*���@��?M���$��Jy�C�ਔL���y�Ƀ���F>�>g�0��K�0C��������/Jk�_���ˆ�߆j�Q���潴������$D��?���+��nx�3�@����BPF���d��ʬ�tf0��԰E�jd�6=#n�퀶kѝ��n��;С]s,�"�纃���4`x�S��;~`�-y�p�t�yF�`l�AZ��7�<t���Ϝ�~���"�fm+Dj( �gQ�0��H�Ѯ�kx�˪�զڀ�S;�ƆK'Ԧy�Os�d7����j�Co���<T]���Rz���u�h�@����r �qq����,D�z;��@)�)��	�4P�ԽGbP�y����O�SOuH� ;��s����|�`��F����������I�/	� ���*`��� �做k��|�4���a hj�B-�A��5Mݬ�^
�ܰ�����M��ŝ��5�B�m���MN���ԛ<����y��%iU���i�҆����� |/�B�aC�����'���tҸ4�8o]��z�r��M��Z��m�Og13�@<>k�-�����Θ����p�i���y[�q�ޢ��c�d�=���d~l� ;���8'"3˪S��Mާ*� ؛� l=6!c��K3�'1ǟ��ҧ�+���Ʌ	���;�����Ǟ� ��p���h h#`#��6t�0�l���缏��sƜ�{�&���#��眧��O�gݤ��x��8�"��ި�&�2��Q�t�L�^P�l�z5B�jy��Mͫ�X�����P�4l���Ra����tog?n��Ą��_���l�!�����6�ȿ(K�i��翫�OJ��a<��;[`g4��3�]=�Y��9��f-X��4ײ(�5�����ʕv>A�p��\�C9Y�Vv~&�	���g߳+�;�gO�Ɛ��h����$^nFI�r���R9wPxq��;�;� t������I��m�"�4rLV��8d�h>MB�n�=�|D:Kw*��[�(�ʇJ.�>8����ڬ����Fd�4{��&j�o�/��γ?���/���<����۷��̆w��Z��[�\���6(W�mU�Ń��^1���.��%���	Z	����!_���e!~�-
?�E��c�f���4���}w����$!���Vk��ˆ��?h9��\&�aQ���b��Z�W�/�ܓO������M� ����j��qBx�A߲��Νa��O�Kwoc������?A_�� ��?��܉n����z�W7]��/;�b����k���z����pl�=�e; Y�^������B�Ղ�f9����ȡ�X�	��Z�SJ�ݝ�]f����?����-7\���c�����'X�ݳ�4Ȉ��5�;Ë���O�_�U��V,ԦJ��X�3�̍�ii��iX��r��j��U�g6�UG\!�	���ÞBݘ	�0��.R����ke�0�:x�3��{g�wJ�����60q������-�M��]����<}�S�o����A�|�Zs�Z���CDX�t)d�3�R��O��A8�=�s<����@@
Aq�
o��"�s�
���[��]��U'�,^����]���D�Nɿ	��%���V��XƖ^o8�:���~�Ox=4���v�n*�wy)�4�7:-�r,���]	�U���?w�����B�����تH3���瀌��e �ZM�]hϣʩ�
�"��V�a��0�C�����Jt�����gm�]���ҌgK����ʻdFY#�~��m�K2�'����;�StLԑ��`2���L~�6�R�̜1��t��Y�1&*���T"��W��ta���S��J�3Ç���a?Jf�ե����)D�ϑ��dލ-�j�T��������6n�/Ƥu��������<�t.��Ax��_!�>��D�u��J�������o����������5�S�營P�*��,ŷj���r֪5Y݊ǣ�j\��D�����ò
�x$����T݊D6��k�/_sӄ7����Ni���/���6�������G�>�$6ml9������6lT��}��&���W�|5�����Y�;{�_6����mp���H��}"8sb�ͫeo�a�1A��a�8N	�h�1�`����f}��+����y��j���?,���j���n�&m,�������Bx��WW�k<�(�j�)�4YH�Mҗ<������<yz=��d)�}��z��������Q�!�
(��5��j[qTS����0"<�Ҡ��eA��Vƫb�8��H�4��]�*"j�F� N�B"��@2]��2��RI��wf>�KfϓIEM֕n.��s%���ǅ=-���𛘎�M��M�Os{�,wy.�	nW�L�
J3��G�D#�<>�_�/�R�^8&�*�f�Q��j��O��s��{�VR�䙞Ⱦ3�V�=���Si�"[Q�x����{g�i��M�Q}���ʑ�$\����+i��xg�fbvwj!_Q��󜔯䄃JN:�e�L��3O��|��&����b1��>>�LW�d��蒉�^Q���䬣�"��J�$�(z#��ޙGR�ͥ�z�'�s��p^�L��	�a(��I�����B��̗#�f5{a�
�j%qFf2��&z��W��l2��w!�$����E�(f��J��wb�7����yĉ��<��*���~��8f��j�pO��@���|�,v�
�X��k��虜�e�ݽ�J%��Wd���Z��N��E�ƻ����s�[�'��VZ9W�|Ҧ��r�b3��Sr��u�X"���3��~�����n	���KHf�y]z�%\��<Y��"ԕ|�(�+&e{�}g&�����)���e<r5̳�T.����Q�8�Ij�z�^��Eq���N�a:���cn����8�{���㱎V8*);�L���Bj���~?
�~��f}_7��c��?��S���9�Q�����ԟ	�cg޲�R�D�W���}>��װ��_��O��	�bd���K�cb�^���>���.���"��
]H}�b�.���~b롸ެFsgʱPߠB��0:F&����^є�q���R�:I�xT(��G��L�^\˭��_TQ�1'7�z�R��(rt�+e�z�qba�V$$AU	����~j�"�J�8�|�-���}�Y���/�����dm�W������=�5<�e�i��_��\	�����~.9n�3�n�{��$���($��T���a�k�3�#Xɼ�_��ݐ-���6<l�s� s��7�HuKgo��L)��X��mqoo�y�N�T�⾭w/��n۬Wr0��wv��t�>���v���v0,���`��W��z�wD^�\<I��Y,.2�ȓoV;� %Zf�b|��'4��0�&�諒xg�5Y�`���������xHV��A �PM7u1�k4���%;��A��N���QK����r�]��i��%N��< � (��� @
��nn���*V~�mS�|��T��e� }�@gT���,��9�%�~�ް��~�nێ�A>��?#�{c.��m��<���e^F~Ĺ��;F�ȤA�4��i�LG�L�ȄUû:�.h�����c!�H�YA��O�3Ԯ��*@�� ��6���]h�\J�T�>蠗�4z|:l�� 4�,أ�B�/�ґMh����h۶N�DP�.�T�/oO�$��%�����bTL��6(���д�|�tуct�dΰ�����2����B�W��G�g���5DUϐ�$к�_�7�u����蓄�'fl!�WW����� ��qr��/$�禭�k�}2�h�d�5�Xg蘇��%�9���m��۔�:����Ǵ����0&ez�[�xR2'�����\)F�#��q����� ���L1U`Y�`����RZs�/N�$���q�pwt/zR��T4Z�B�*a�f �:�i5�\6z>A�xp(��Rb`�$�&���M�ZU<I�N@��)v�������G{�,!x�*m���v�|E,󵩡�L�o���aEߥ�OZ��ɱ\���SQy>X����0��nd�=eH'�&�n��K'�(�pm"EDW��&�*v>=_�{��i�^�P���F��rM�e�N�V �C���Շ�X�Ul:����8�2�〷l�^�>O��o�Ȱ`$2D��d>�>���������/>�8�,��C���2��Զ����>k5�I��x,��zĆ;�@K6џ�[G&��v�����6��E9,L�������]K��XZ��i����)R�
f�L7�K����2%�;�s�<�'�+'v'���N�d��B���i@�A�@�CblaX ��ĂB�5�?�<�*�F���[���}��9����{I��G�P�K�G������_~{�����I�犁���/��?���o>�������8�=Y �q�����u�#�~ܺ�.&T����T(�	��!9BEk1C�HS�1�")���cd�#H���8A�m)#��I4��گ�×�o��ԏ����?����������~C��~�����+�����}�6���~������C�kB)����/��!���-��oA�C Z� �b��E��t3׍F�ǆ���R�M��O�N�����K��%@W!��W��*ć�jL�.�
�QU\K`F6k.�u��"�3�J����%M��\�H�א�g�Y�{�)a_�i�Vi�"
E����9f����1�-��+�f���R�����0�m����	ž�0a�Sn�X�o�3�J�^��f�<�1C(�f��7���%rw�kT#��Su�����1�<M/���9�T��a����~�/�l�/�cM��N�҅j1u�o"�e"����ss�$�e��Hv�l[H`&�Y��t!�2�����@��1���G��I�I�?h�5af��\6i =[�c9+�9�S�$%C;��\'E�T�ϥ��H�fw�f�6Zd��~�;>ob٢Ue��;�Ť�j���%�#�<��屚)S���8��[_�f��8��i�2II�j�l��0J��MJ�͍��+"��B��������<��+��.�K��K��K��K䮸K䮰K䮨K䮠K䮘K䮐K䮈Kd���`�E�,�h"��IR���QJ,P;Ǟ��f5/Ƙ�������Ŷ�!�E��(p.T��|� �sՃ��B�~kՃ �s;�5SV�=ܼ�5S�S?��j��2OM�X1IOCs��7�l�P#��Xn��,��b�ї�2�B-M���Vy*�(K�F���X�6����Im�@]�~W��D�D#�}�caLBbe.;[�r���S9��-M��y�u���'C�f�XG�\"F)� LvH3�3e�L��NL]�!#��~��k�=c�l�O(\2wZQ�r����򈌵Y��o��Y�p�p�wa�.~};�G�>޲�}��Go��[����V7��_½7v���ϐ���-�8��[���HS[��'�w��8r����ɇ:�kP���^<�Eo܁��՗7o^�:pQ��~ z��A�߾��>r~��G���0�����?�ރ�q�(�,-Q&K+���YN�U&�TY.R�Qr����%�E��K�\�'6��e&l��r&	XJ.�6V�`)OWr!������EW��:��2�M	\��+�s@��-�(U��N�Q<�RØ �Y�F)U`�x"�Rq*}̎�J�W@bT>\��ʱ��0�YO�,�PO�-���JK'Mc��z�]]��tG������HM�s���BղTw%�f-��t���f��`D�*�!-�l��2qFjrˁ��hG����q�r�RrtnI����'J�n����%}��)�N6E�G��ZS�|-���ny0�����"�~-gY�l�}�/�-�2B:B3��1���q���nXS��a����a��Z	�,�H��=����d�80����\��Q�/
�4�ᢙ�ޙv��-�?~���,0���3�rbIW\�d��~D<�b�5V�B[_d{�"��Ymd=��g��̬������m��ew��=��tϲ��fU���S��L��=���j"o�:����zR��J�-�%%�A��U�P+�e�φ��Q��Y4b���:/�yzU�>���T�~��
��C�+�@����نr\�i��f�/����Ts�u
�0�I�泎֞G���SkO'�:����J'�L[��dUX,�]Z����Z4�$%���Ų<�ҥ�,�0�6o�����Ţh1L���d*���S*�E�vk�0����4�c�/��hzYxv#����䉬�b�H��lPkjd*�1&#w���e��Mv��dd&iG�����!�=��&T&�m�`\e����K��dm�\eR漫P���j�RJC�r�u�V�sH�<ժ.6�X��u�]%��F��wny,�qI�c�z%#�g)�\U�ɐ��Ng*]v'@��V� �F١P"�L]<3���Ҕ���B'=CS��;A�RXH���S(�ͨ�(�w�i�МOqR�T�H�j�y����F�
>*[;LF-�c��ul*���Ps���ʆ���h���R��r�e��٥��]���oY6�#�]�n����"<���eB+��څ<�����-ZTtc��_�Gn�G���,8�U��Tc%� ��>�F^����0���ԥx/���������ϟ�<�BށyD�QR������ʳç����"i�l�����kz���+�7O#R�B��ZgdU� �qD�7�'���q��!9J��t������u/;�<p��剢� ����S:��u�^�^f�y����n���������0]���B[��!���o����6��'�~0�u�zd�v[�~'אn��;�0�JP�^��`����[�t&ê$=8�&�@1��ؑwR{G���}��rF�������>G�&����W����]= �;�9	~�amT���!�G����y�tu���}f]/���u��+Z�Zu��^���9�щ��z�|.�vL���������"�	:Y�G�	j� �G�~����( �h#��f��D��Z7 D� FW��BE_�oL���v����4Zcp�X�x�,Υ�`�7�zw4���P�t v9�����=_ͩ�� ���|�V�ت���ć��I�I��,�QСwA���9��
Zt��?_} k���������*Ù:��^�5�>蜯6��Dj���Y�A����W���_��'�N\l+Mv�dt��9��u��5��*��:	�]BG^�WĀ��Mt����X�Nl�Z&��C/:��VB ؆��:l�cI;	GV�'0\Y-j%�ȗ[/$�̀\1�ces�7�ןzP���f���	�v�!a?�Z[�o�ŦB�.�Y������Hס����:�n��CG�[� :l*DO��a�7�rMg��[�܇>��Ih���X��F��Q`[����$%�I��4�\vu�J]����EP�͖�Z��P��b�	�l} �u�dM"[W���6���	rO�;��y�6��� @�+�K%��D�Ꙥj�e��~�%CL����K6��i�nd�����+Nx�h��v�b�c��� �<�б�~��
"�G.j�P)�ea=���� ���R�������e 
�9� \�U導5�"̓�]֏�Hsu0�j��v�L�P ~��{(ܤ�S�B����Mk���n�2Úd{�����6A.��~d�xk��^���fK^uqձ�+�4a��4��߻<���Ŗ�/�A�}l|��۰�-��V}5Z�;-B$�E����[�d��v��|x�]M��SgFN���Zf&�>PV�5U�t���H�P>fu\�뾊�9�;x� �?�Q�#c�6q���8y���9'1,F�$��r�c�]���v��$����l(�D �n1����+��0Ts4�;rc�R~��qC���~T��S��Q�b��];����^s��u�s���7W�q��2Bl��$C�p���V2�'�'H@m�VɎ������N�d�mxV��4S��gq�D�x�*F�Y�C�;
��b�+�߲�UŎ�"]V
|<K�k4�ڵ���8�}:V�h蔫߬� d�"�&!IM2#�)!�MQ�VKi�r��K�Y����n�c�G���3�o2��|���+v��̉�cY����V����o����)*�r�Q�Xo��:���fU�1�I�R����Q,"K2N(�&�$I��pL�`Q*����BHH!k&�1%Qp��kb�O�v���sl�ȟ�٘Yv�@�M�S��{疄�\w4�8����{r���ʸk_�����Wp���m��rE���\�+ҙ�L.��*\晬4�����%���,[�J�g���s�K|I��T�}���Ⱥ��ܓ�.�]2�8�Jy�}�;�*7�t�Յ�>vϺ�
��{kGv&��t46��������vT�;mBZ�^�u�uT�`t�e���;�&�m2u�k-����0Q�:����Y��> �M��\L�[Q>/��x��"O���Y�����S4����UN�'X�)'׳V�3.��s|V|6��E�=kt&M��t��VOu?}��3�"/==��u��لGK�}cs�S�h*W�l�O�e9��+�
�螹lt濴������ۙ��v�yZLm���,�E�ؤU�$�"g�di�f��,B���%��r<�2Θ���	r#���h��2���ӣ��g����gmIӕX__$o���=":Y�����54<�Ew�n��X�[����+��]V��P��Vw�y�� �ȥ�����w����wǊ�[�q�2g�b�jb3p(�pTtz}������]/���,�K��"��/�Hw\�m��ƍ�?d���a���^��o��۬������Gz%�����o���{����-�6aCii��O��/�U���m�2>��}�}����O�=_ٴ/���_���������^��������@s�,}��J���_�o/i_��"�$k�V�(֎Deܒa����Rd��D�BE�h;�
��P3�*MLV�0!����E�_��*��C�m���%���0�7�i��k��P�#��NS��qEl��)�a�|��B�����'��?�*��T��5�A�ͥ�3rX)D��H��ȟV�e����R7BҲ>o�㧓R�ޛt*�IWK�+!,��j�:�wǨ�^��'K;���*��������/�ml�}��v�}��m��q�p����*��q�:��}�}�����=��|:�������u�GF"���t�� ��{
��� �����?�>�9��{I����Wq�pJ��t����򟤶�?u���H����~?;�D���%�/��	jK�����}�C��C��C�Οh����wm݉����_����~y�cn""(^x�o��(��h����I�*@W�|JY����5�Z������G)���<(�+��_[�Ղ�������P#����
P������?q��-o�������?��ߛ���د:\;�������E%���.$��O���������1Do�����~"���s��dV	�O����}"K�� ��e�P�s���v��63٥�������{c�:R��V�o�:�h�n,}d^�Z��¶�1T}�Fj�y[�D~d�S���-��Q����z�5�v�|����T�ɹ;�,g�tK��ާx�-�+g�&��{�ı+�h�]��5���i M
�{�DU������r�^ٰ�1�i�w�/w������3�fV�w3j����_j���D��P�m�W���e��CJT٨E�� �	��K�?A��?A�S�������+5�Y��U���k�Z���{��O���Z���o���Q�����Û����������	���d��h\��Uܧ��������W�������>wGó.�}Y�������N�4䉏�T�fq�G[onk�Bp�j�6�%:��\�f�FNvUA�rL,8��l�#zF�&��O��R6�0t9{*둿��!���S]/?��:���sI�D3W�/m|���oߺ�����y���v�#���q�Y��&��p3�/�	�B0���*���|�>t~8sMR��劉.7l�9�Φ*'�]�K��pmL������������+5����]����k�:�?������RP'���|�	f6P�R,�,�R�hH���Mx4���D@�>�pF�����(���r�+�����j�S,$�f�i�H�d�qWp�t�s☷-}��|E|��7Yvjm��`~���aH���9g1=`b� �y��-ǧ�y6�|�!D?�1R�Er,IN����a2��fDE����Toچ�����������+��V�:����������5�����ǥ�������C�W~e�w0L�>hr�ELd!w0�����ew'���.�
��p���.A����1���p��Q<�hΑYnŁ(�\]F� ��H��j�W�О�5Z�t���)�F6mߥ��{/�q�����5�����w|m�����U����/����/�@�U������s���_xK���E�E����~D�����z�tO&��ir��?]T��_��[�k3Ȑ�ښ�� �Ӄ?q �g=����T��*X��*r=��3 x�8Kȁ���Fw�Z�l�%�tw3��h5�����faY�@� oD�`�e�1/Oet<_ډ��s/���-8c�Y/"7ȑ�5�Q���9O�W��`:-!ׅK=�"�%\�'�/�q`@��v3�������X��uB�X#�ʲƸGX�� -���y�4��[a�����ED?��I�˦��C�v���d��N��Dkq<�Ijw�$�l��i��u�XX�\3���}	�_�׉�&G��>b��$Xst^�m;��hP����	��|��?�`£�(�����C��?(����2P������/��?d��e����?��B������������6�	����P���8ϧ)��}�dQf�M1<$��<ϣi���ِ����4���)˅$b텰��i�C��h���O)���n�?,5u��z��8B�>>��I2rrnl�dA:��T�2�k$�Fr�lY�Г����a�f��|�lք�K�u��P\�����<�Q�!W�+�����;�uG;�#ݖ��ĺ��E������J����5��g	�;�q�?�������w�?����r�ߛ�c�x�#��������U����P:���/���5AY������_x3��������ơ���)(�d�ĉ�\�w��AQ����{��o7����~_C~f����F�q�;�G�h��F��S-�ț��ʁ�N��)˓e�ä{d�q<�FjOKsd4�;B{�]���j��&��k-oj�1�3.㦹��f��?�]R>+Q�-l[��<� �^����~���Hz�8��޹ށT�Cv��2���tm����z;Tl�z�w�6�y�����eGTM��4�FD9���$$Y��לo�#�ThmFN>����Eit�6:�i�J�ԓ�\瘃���z���Y$9�85�_���P�wQ{p�oE(G����u��_[�Ձ�q���׊P.�� x�P�����7M@�_)��o����o����?����U@-����u���W�����Kp�Z���	��2 ��������[m����7
��|����]h���e\����$��������}�O ��������?���?����W����!*�?����=�� �_
j��Q!����+����/0�Q
���Q6���� !��@��?@�ÿz��P�����0�Qj��`3�B@����_-����� �/	5�X� u���?���P
 �� ������"�������j��������(����?���P
 �� ������?�,5�Y��U���k�Z���{��翗�Z�?����:��0�_`���a��_]��j�����Wj����9�'���
 ����u���{�(u���Aڟ��(;c�p�>p$N���٩���2�c��qIR����z����4�E�S����K�M����}�8��@ͽ�7`���y�+hI���O#n��6e�ZW-)��fn��|�"�vG13c��βhy"�(��Z\%?�r�t��:S�UH9�6�đ8m�$9�=<Ľ�oJ��ܕ�6�CA�'�����{RU��5C����Y*���W���u��C�Wj��0�Sj��Ͽ��KX���Q����:����:uj�{v�jl��7��Pl/��b�\�e��g>�7�K�g�˽u�VF�${����4^$s6���qH=5
Oة�n��� ���R�'�I���.�{�6�%4� m7��\���ދz������$���x����7��_��U`���`������W���
�B�]>�������_�)�O����N2$đ��7���GV���7���W�gmw�v��
�����Dޓ�G�]g�L��ِ�KnK�V{����Hd*��Q���i0��#�t��2r��H[��(��vFd�q����9�ٞ��J�#��n���׌��K'^��M�%�py/�Hn	����u��e����f�CC9�g�b��B��T�E�q��z�A:Zv�,�l�j�9�Ζ�������'bv���q��Oݓ;���t���ǂ:O	l�u�DŦ�r�oL9O��=��aK,��MJ1[���O�����׷�׿����(�C��|��}���_��G��e��F>�����R�ٟ��D7�-ʸ�?��$�1��e�����}���/���s�'dz�e��?�0��?�)����[��a�"?=��Ѝ��L7�9�'t�s���:p�/������[���,Mr��q�.?��+]!=�CW�'���7��������|��k��Ӆ�f]���չ��� �-ټ-D��Ӫ
�]W]��@����341md����H��V����d]�����]�R#\.v�y+��&F��]̠W���
�*��1F�b�K06�|�E�>YyO�7��sW�˚�D�~�K|�f�!O�l_2�M]|zOL�ȌQ`������n���A��ͨsl�M���S 퐥G�m���m^d>�y7�X��e��FM�#޵��;���!W8b�Ո�H���'��i�����}ڛ��M�\�m�F�ՓV=����n���������[���O�>����X��=nF�wy��n��8�ӳY��7�Ƨ*@C�ü�)lv�P����_�����_9�/�ьo���ڏ���"�;�M�~�-a���}J�M�+�/���r��j��\����/>��5?���0��2P��1Ľ��������(��������4�R���-������S��gg��FgCfcz:��?�.�����@��SO���`C>��-���!?��]�?���X���׻�~7�y��g��j�B���́�NCJ�aka"�'GGmʭ1��FU�n�k����<�yq�A�*���|��F�x��D��v�W����w��������:�f��Li����=%��jt:K����G�:Y��<���x�����c��Y��j�c�\�{�%B)�if륓�v����[�hfJ3�96�\�����E�l�������̗���wC��h��KA	�ʣ2i��Pb�����З�(&g�Oy��z,z����,F��Q�G0�#���D�q���#�>���>���k��u�`�ޢ���o#'N��+�q"���^ ���v�����l��䣲����?�׀�����W��.j�^�����@���'<�����U�?�U����9�A�AY�������gp��K�[����;�ќt���M����l��E���>�!����.������s[?���(���-D�� ȱd˄.M��B>��l���c��cҷ���B��:W�G[W���tt傟���t�i-���sR�����ܜԩs���Cz��V*�����[9��� uj��mw҉Τ3�f3q}���D��w���Zk����+�������I-���(tƵN���u�CO�p�k�f������QX����7ǧڪ�`b���fqo3+S,�m�JGpK��\������V�Y���2����������7��>KQ�Ɗ'��͡�zv��(v�~��kkW�ǋmÖ��ac�8�*#[���E��~r�^WYMm�0&��)�F�Z�ù_U��^�Ģ��m;kV�^o 8�]0%�.[+��(U^��G�~yA�T�"��e��z���7�i�`�Q������LȢ�74p��
���m��A�a�'td���?r��_��E�������O����O�������p�%��߶�����td��P.g��������?��g���oP��A�w��ޢ�?����*��"�������?r���E�w������E�?�9����_�����L@��� �k@�A���?M]���O�R��.z@�A���?se�
�?r��PY����`H���P��?@���%�ye��?2��I!������\����dD�2BБ����C��P�!�����P����������������\�?��##'�u!�����C��0��	P��?@����v��J������_������o��˅�3W�?@�W&�C�!����!���������#9��AJ�oe��Lp����m�y��"u������78��LR/�sV3��ss�*�&cX��*�X��K&e0�aYzYK���I�I�ȑ�1|�[��'�_�.���φ�����oT����\����x���&SN~�%��u\��2k��@�ks�icr�n���ǁ4łZ��ضߠ��V����hO��Ң'��Ճ�k�[4}T��]��RH�l��f��
kI�\e�=��4U�Y�9�v�Z5�(W�gnq��[_�K�uT�AyEV|����]\��y����':P���f}�@���Б���t�����'n �V�]������G��f7iyW�u�11I,���l��8n��zږ�]T[��i���kTG�����6�x=r[�l��`�R�K�#���Rm���z� �k8W5��.����o������Jl�A
�S�'���Z���a�(�C�7���Q�B�"���_���_���?`�!�!���X���K~���߬��h��?��5?�=�gF�\���������>�bE��3������(ξl�^��	�"�M�7�$ɶ���[���X�G��N
|I���Ċǅ-��;<���d^u��4H�Go�km��������!���R��ۦ����s��U�0�"�m���z���@��5�kT��(v���{������D�ĉ�`�77�jEp�W�|/M>�ͧ$6_Mp�%�N-g�Օ�Zso�i�m���y�l*S!~8��ôU%L����0�!�.�����!C�G�.�������&�Z?����<���P������S����5�G^�� ������J������Ӌ�5��O@�?�?j������Y��,@��i��q@�A���?u%��2���Xu[�"���������񿙐'��*�ٓ��o���������?B�G��x�����������	��?X)��߶������������������ �#���qJ�?���JTڷ�#v��U�{nn�� ��#�u��?b�1�#M���X���1�#�0���~���+r'Mq����~��}��^���-:Q��OT���8�S�c֖]��u��1/o�V{C*��^p6dg�4'H�4B_��Ì5>M65�v_�i����}N�Ů��jz��qD��ah�iT��H����؇ceZ�{���LW'��]����y\u&�N��fD�s�3�I[��6��D7ܬ���5��6���'�nŢ���fmf{�a�,U�0��OG�_�ng� ���#���bp�mq�����_.�����'�|	� ����J�/
��3�A�/��������� ���yp�Mq�����_.��%A��#��� �5���!����+�4��E�Gu;��E$W.�Ԗ=hN�?�������q,������魍������{9 ��/�r J�p[+��q�h���f����ME����R�}3$0%�{%�rԧao�,�m��"��R�X��a��v �&�� ,M���^,�=A�ǍuaQ��B�R�}%Z��̹*6��.,jay��dY�J�Ȇ�MK��zdR+�5��4�EҦ�qݚP�V�/ܟލ�����������2���ip�-q�����_��H]��X�ς��?SfxC+��i�V.i�H�Œ:��K[4M��&K��e����Y.����>�ou����A����	����#���3��0nI��|���d�4�Z����d�k�֪fN�r�y��c��Mh����h� �[��v�j������.jZk���ܩ�Ѕ�i�Q#� WO�q��œ�e�8����FX��������@����@�n�'�?��ȅ�C�2����"����)n�<�?������?ޭǋeM�ȪH�I�B�m�[n���ZtwJ�b�D�������#�������s�5!��Cc�b~t�WG�,�x�N����vŇ�Wͨ-���T�謽�?n�uhM.C���Z���_��<� �� FH.� ����_���_0�����ѐ��e�`�!�[��8��l����0|n��;A��8nI�"��/o�=� �H��� `���(��p���\�մnArx��Zq���;M7V��9*���|*c+�h,g%>:r\�b[-��։���z�*�
�m[\/%qu����R;OԄ��}����kU�T�ú�c��,t�51nJ_�`�LJ���'�a�/�d7�j��H:q ۖW����"�1������,<e��4��D]��!=Uꟶ-?ۋ�W�E��D��Ҽ�Z7[�lH�H>�wɩ�P8��ٱe,/V����c$��B�=,�=5�W#Z]����·S�G�e�/g0~��/�8������G�������I�/��f��A�3�ܝۦ�'��@�L��s�p�eg�6��|/�� ��T�?v�A���θ�������������KOwN�l*��ǄN��y���E��3V������>o����Di����~>����?�qpxyP����ş_+�y��_����1�}�ӧ$�=n���ߘ��8������x�ߞ���;.�k����WN�{.n9A�fx�?q?p������h�<��B3���}��F�9y����.01�'�?�g�j�DN6�I�,��G7vA`&Ǜ;A���������?pc��?��o|��Q��?��ÞT�_��~}���;����x��J��=��� �����c�����I���.�'�����Y'o��p�����ӫ���]-/��G����6��8ᑇ?>]�n�kh��=���!/�v��6�N�-���w�pg�_
r �J��>�{��'���n��������rm�_�pm��onM��,��/�I2�ל��i�i���K'��������w~e<�_<ɒ�@-�isfd�ύG<��D>=Y�s��:���_\��Wq��xR�W�ةV{����n�����8�4�a��y^���OJwx���Y��{�}�O�`z�����7�G                           ��?ή2 � 