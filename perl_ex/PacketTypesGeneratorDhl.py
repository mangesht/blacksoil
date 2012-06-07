# Use the following command to run the script
# /nfs/nova/tools/latest/bin/python2.4 PacketTypesGenerator.py > PacketTypes.txt
# The script writes to stdout and has to be redirected to an output file

#chihwang - note that argus should also test error cases for all fields

l2Tags1 = [ (), 'MacSec8', 'MacSec16' ]
#l2Tags5 = [ (), 'Sil', 'Fch' ]  #argus to randomly insert this
l2Tags5 = [ (), 'Sil' ]
l2Tags2 = [ (), 'VnTag' ]
l2Tags3 = [ (), 'Tag1q', 'Tag1q Tag1q', 'Stag', 'Stag Tag1q' ]
l2Tags4 = [ (), 'L2Cmd'  ]
l2Tags6 = [ (), 'L2Sia' ]

#chihwang comment out l2Tags5
l2Tags = [ l2Tags1, l2Tags5, l2Tags2, l2Tags3, l2Tags4, l2Tags6 ] 
# MacSec in MacSec over SIL is not a valid usecase

#chihwang - four types of l3 that dhl cares about
#  1.) ipv6 with no extension header
#  2.) ipv6 with fragment header + random headers
#  3.) ipv6 with any random ext header
#  4.) ipv4 with random options

ipL3Tags = [ 'Ipv4', 'Ipv6', 'Ipv6 Ipv6ExtnDstnOption2',  'Ipv6 Ipv6ExtnFragment']#, 
# 'Ipv6 Ipv6ExtnFragment Ipv6ExtnDstnOption2',  'Ipv6 Ipv6ExtnRouting', 
# 'Ipv6 Ipv6ExtnRouting  Ipv6ExtnDstnOption2', 
# 'Ipv6 Ipv6ExtnRouting  Ipv6ExtnFragment', 
# 'Ipv6 Ipv6ExtnRouting  Ipv6ExtnFragment  Ipv6ExtnDstnOption2', 
# 'Ipv6 Ipv6ExtnDstnOption1',  'Ipv6 Ipv6ExtnDstnOption1  Ipv6ExtnDstnOption2', 
# 'Ipv6 Ipv6ExtnDstnOption1  Ipv6ExtnFragment', 
# 'Ipv6 Ipv6ExtnDstnOption1  Ipv6ExtnFragment  Ipv6ExtnDstnOption2', 
# 'Ipv6 Ipv6ExtnDstnOption1  Ipv6ExtnRouting', 
# 'Ipv6 Ipv6ExtnDstnOption1  Ipv6ExtnRouting  Ipv6ExtnDstnOption2', 
# 'Ipv6 Ipv6ExtnDstnOption1  Ipv6ExtnRouting  Ipv6ExtnFragment', 
# 'Ipv6 Ipv6ExtnDstnOption1 Ipv6ExtnRouting Ipv6ExtnFragment Ipv6ExtnDstnOption2', 
#'Ipv6 Ipv6ExtnHopByHop', 'Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnDstnOption2', 
#'Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnFragment', 
#'Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnFragment  Ipv6ExtnDstnOption2', 
#'Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnRouting', 
#'Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnRouting  Ipv6ExtnDstnOption2', 
#'Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnRouting  Ipv6ExtnFragment' , 
#'Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnRouting  Ipv6ExtnFragment  Ipv6ExtnDstnOption2', 
#'Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnDstnOption1' , 
#'Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnDstnOption1  Ipv6ExtnDstnOption2', 
#'Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnDstnOption1  Ipv6ExtnFragment' , 
#'Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnDstnOption1 Ipv6ExtnFragment Ipv6ExtnDstnOption2','Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnDstnOption1  Ipv6ExtnRouting' , 
#'Ipv6 Ipv6ExtnHopByHop Ipv6ExtnDstnOption1  Ipv6ExtnRouting Ipv6ExtnDstnOption2', 
#'Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnDstnOption1  Ipv6ExtnRouting  Ipv6ExtnFragment', 
#'Ipv6 Ipv6ExtnHopByHop  Ipv6ExtnDstnOption1  Ipv6ExtnRouting  Ipv6ExtnFragment  Ipv6ExtnDstnOption2'
#             ]

mplsTags1 = ['Mpls1' ]
mplsTags2 = ['Mpls1 Mpls2' ]
mplsTags3 = ['Mpls1 Mpls2 Mpls3' ]
#chihwang - otherL3Tags not needed in dhl
#otherL3Tags = [ 'Trill', 'DCE' ] 
#l3Tags = [ ipL3Tags, mplsTags1, mplsTags2, mplsTags3, otherL3Tags ]
l3Tags = [ ipL3Tags, mplsTags1, mplsTags2, mplsTags3 ]

#tcp, udp, udplite, random else
ipL4Tags = [ 'Tcp', 'Udp', 'Udplite'#,
             #'Sctp', 'Icmp', 'Igmp',
             #'Gre', 'Gre+S', 'Gre+K', 'Gre+K+S', 'Gre+C', 'Gre+C+S', 'Gre+C+K', 'Gre+C+K+S',
             #'Ah', 'Esp', 'Esp L3Cmd', 'Ah Esp', 'Ah Esp L3Cmd', 'Ah Ipv6ExtnDstnOption2', 
             #'Esp Ipv6ExtnDstnOption2', 'Ah Esp Ipv6ExtnDstnOption2', 
             #'Ah Esp Ipv6ExtnDstnOption2 L3Cmd', 'L3Sia', 'L2tpv3-Ip-COOKIE', 'OTHER-IP-L4'
             ]

l4Tags = [ ipL4Tags ]
#chihwang - payloadTags not needed in DHL
#udpOnlyPayloadTags = [ 'CapwapCtrl','CapwapData', 'CapwapDtls', 'OTV', 'LISP',
#                       'L2tpv3-COOKIE', 'OTHER-Udp' ]
otherPayloadTags  = [ 'InnerIpv4', 'InnerIpv6', 'InnerEth' ]
#greOnlyPayloadTags = [ 'Erspan-II', 'Erspan-III' ] 
#ipOnlyPayloadTags = [ udpOnlyPayloadTags  greOnlyPayloadTags ]
                      
#payloadTags = [  greOnlyPayloadTags, udpOnlyPayloadTags, otherPayloadTags ]
payloadTags = [  otherPayloadTags ]

printPktTypes = 1

def flatten(x):
    """flatten(sequence) -> list

    Returns a single, flat list which contains all elements retrieved
    from the sequence and all recursively contained sub-sequences
    (iterables).

    Examples:
    >>> [1, 2, [3,4], (5,6)]
    [1, 2, [3, 4], (5, 6)]
    >>> flatten([[[1,2,3], (42,None)], [4,5], [6], 7, MyVector(8,9,10)])
    [1, 2, 3, 42, None, 4, 5, 6, 7, 8, 9, 10]"""

    result = []
    for el in x:
        #if isinstance(el, (list, tuple)):
        if hasattr(el, "__iter__") and not isinstance(el, basestring):
            result.extend(flatten(el))
        else:
            result.append(el)
    return result


cross2 = lambda ss,row=[],level=0: len(ss)>1 \
   and reduce(lambda x,y:x+y,[cross2(ss[1:],row+[i],level+1) for i in ss[0]]) \
   or [row+[i] for i in ss[0]]

def l2Checks( l2TagStr ):
    valid = 1
# Assume L2Cmd cannot appear without MacSec except internally in Superswitch/satellite cases
    if 'L2Cmd' in l2TagStr:
        if 'MacSec8' not in l2TagStr and 'MacSec16' not in l2TagStr:
	    if 'Sil' not in l2TagStr and 'VnTag' not in l2TagStr:
	    	valid = 0;
# nice to have, will test header skip
# Assume FCH packets from CPU/Feature LC will not be encrypted
    if 'MacSec8' in l2TagStr or 'MacSec16' in l2TagStr:
        if 'Fch' in l2TagStr:
            valid = 0

#VNTAG will not appear without dot1q
    if 'VnTag' in l2TagStr:
        if 'Tag1q' not in l2TagStr:
            valid = 0

#SIL will not appear without dot1q
    if 'Sil' in l2TagStr:
        if 'Stag' in l2TagStr:
            valid = 0
        if 'Tag1q' not in l2TagStr:
            valid = 0

    return valid

def normalizeTags(l2Tag, l3Tag, l4Tag, payloadTag):
    tagCombination = [l2Tag, l3Tag, l4Tag, payloadTag]
    #print "Normalize(enter)", "L2:", l2Tag, "L3:", l3Tag, "L4:", l4Tag, "Payload:", payloadTag
    valid = 1
    skipOtherPayloadTags = 0
    skipOtherL3Tags = 0
    skipOtherL4Tags = 0
    payloadTagStr = ' '.join( flatten([payloadTag]) )
    l4TagStr = ' ' . join( flatten([l4Tag]) )
    l3TagStr = ' ' . join( flatten([l3Tag]) )
    l2TagStr = ' ' . join( flatten([l2Tag]) )

    #print "Normalize(enter)", "L2:", l2TagStr, "L3:", l3TagStr, "L4:", l4TagStr, "Payload:", payloadTagStr

    if 'Ip' in l3TagStr:

        # Extension header DestinationOption2 has to be the last v6 option
        if 'Ipv6ExtnDstnOption2' in l3TagStr:
            if 'Ipv6ExtnDstnOption2' in l4TagStr:
                valid = 0;

    	# Mpls goes with InnerIp header
	if 'Mpls' in l3TagStr:
		valid = 0

	# MLD snooping uses ipv6+icmp
        if 'Igmp' in l4TagStr:
                if 'Ipv6' in l3TagStr:
                    valid = 0

        if 'L3Cmd' in l4TagStr:
        	if 'L2Cmd' in l2TagStr:
            		valid = 0

        if 'Udp' in l4TagStr:
            valid = 0
            #if payloadTag in udpOnlyPayloadTags:
            #tagCombination = [ 'Eth', l2Tag, l3Tag, l4Tag, payloadTag ]
            #valid = 1
        elif ('Erspan' in payloadTag ):
            valid = 0
            if 'Gre+S' in l4TagStr:
                tagCombination = [ 'Eth', l2Tag, l3Tag, l4Tag, payloadTag ]
                valid =1
        else:
            tagCombination = [ 'Eth', l2Tag, l3Tag, l4Tag ]
            skipOtherPayloadTags = 1
    else:
# chihwang - comment out since there are no payload tags        
#        if payloadTag in flatten(ipOnlyPayloadTags):
#            valid = 0
#        else:
#            if 'InnerIp' in payloadTag or 'InnerEth' in payloadTag:
#                if 'Mpls2' in l3TagStr or 'Mpls3' in l3TagStr:
#                    valid = 0
            tagCombination = [ 'Eth', l2Tag, l3Tag, payloadTag ]
            skipOtherL4Tags = 1

# We do not expect to see Mpls with vlan tags
    if 'Tag' in l2TagStr or 'Stag' in l2TagStr:
        if 'Mpls' in l3TagStr:
            valid = 0

    if 'L2Sia' in l2TagStr and 'L3Sia' in l4TagStr:
        valid = 0
        
    if l2Checks(l2TagStr) == 0:
        valid = 0

    if 'DCE' in l3TagStr or 'Trill' in l3TagStr:
        if 'InnerEth' not in payloadTagStr:
            valid = 0

    #print "Normalize(exit)", tagCombination, valid, skipOtherL4Tags, skipOtherPayloadTags
    return [tagCombination, valid, skipOtherL3Tags, skipOtherL4Tags, skipOtherPayloadTags ]

l2TagCombinations = cross2( l2Tags )
#print "L2 Combo: ", l2TagCombinations, "\n"
l3TagCombinations = cross2( l3Tags )
#print "L3 Combo: ", l3TagCombinations, "\n"
l4TagCombinations = cross2( l4Tags )
#print "L4 Combo: ", l4TagCombinations, "\n"

flatL3Tags = flatten( l3Tags )
#print "flatL3Tags: ", flatL3Tags, "\n"
flatL4Tags = flatten( l4Tags )
#print "flatL4Tags: ", flatL4Tags, "\n"
flatPayloadTags = flatten( payloadTags )
#print "flatPayloadTags: ", flatPayloadTags, "\n"

totalCombinations = 0

#Main routine for running through most combinations
skipOtherPayloadTags = 0
for l2Tag in l2TagCombinations:
#    if 'MacSec8' in l2Tag or 'MacSec16' in l2Tag:
#        if 'Fch' in l2Tag:
#    		continue
    skipOtherL3Tags = 0
    for l3Tag in flatL3Tags:
        if skipOtherL3Tags:
            break;
        skipOtherL4Tags = 0
        for l4Tag in flatL4Tags:
            if skipOtherL4Tags:
                break;
            for payloadTag in flatPayloadTags:
                (tagCombination, valid, skipOtherL3Tags, skipOtherL4Tags, skipOtherPayloadTags) = \
                                 normalizeTags( l2Tag, l3Tag, l4Tag, payloadTag )
                if not valid:
                    continue
                totalCombinations += 1
		if printPktTypes:
                	print flatten( tagCombination )
                if skipOtherPayloadTags:
                    break;

print "Total Payload Combinations %d \n" % totalCombinations

# print other combinations that dont quite fit into the above logic
# arp, rarp, 1588, Mac-in-Mac, pause, PFC, SAP, SNAP

# ARP combinations
#chihwang remove l2Tags5 as this should be randomized
#l2TagsArp = [ l2Tags1, l2Tags5, l2Tags2, [(), 'Tag1q'], l2Tags4 ]
l2TagsArp = [ l2Tags1, l2Tags2, [(), 'Tag1q'], l2Tags4 ]
arpTags = [ 'Arp', 'Rarp' ]
l2TagCombinations = cross2( l2TagsArp )
for l2Tag in l2TagCombinations:
	if l2Checks(l2Tag) == 0:
		continue;
	for l3Tag in arpTags:
		tagCombination = ['Eth', l2Tag, l3Tag ]
		totalCombinations += 1
		if printPktTypes:
			print flatten( tagCombination )

print "Total including ARP/RARP Combinations %d \n" % totalCombinations

# PTP 1588 combinations
#chihwang remove l2Tags5 as this should be randomized
#l2Tags1588 = [ l2Tags1, l2Tags5, l2Tags2, [(), 'Tag1q'], l2Tags4 ]
l2Tags1588 = [ l2Tags1, l2Tags2, [(), 'Tag1q'], l2Tags4 ]
l2TagCombinations = cross2( l2Tags1588 )
for l2Tag in l2TagCombinations:
	tagCombination = ['Eth', l2Tag, 'L2_1588' ]
	if l2Checks(l2Tag):
		totalCombinations += 1
		if printPktTypes:
			print flatten( tagCombination )

print "Total including L2 1588 Combinations %d \n" % totalCombinations

#l2Tags1588 = [ l2Tags1, l2Tags5, l2Tags2, [(), 'Tag1q'], l2Tags4 ]
#chihwang remove l2Tags5 as this should be randomized
l2Tags1588 = [ l2Tags1, l2Tags2, [(), 'Tag1q'], l2Tags4 ]
l2TagCombinations = cross2( l2Tags1588 )
for l2Tag in l2TagCombinations:
	if l2Checks(l2Tag) == 0:
		continue;
	for l3Tag in ipL3Tags:
		tagCombination = ['Eth', l2Tag, l3Tag, 'Udp', 'L3_1588' ]
		totalCombinations += 1
		if printPktTypes:
			print flatten( tagCombination )

print "Total including L3 1588 Combinations %d \n" % totalCombinations

# For various SAP, SNAP encap refer http://wwwin-people.cisco.com/rtamaela/l2-frames-format.html
#chihwang remove l2Tags5 as this should be randomized
#l2TagsNonArpa = [ l2Tags1, l2Tags5, l2Tags2, l2Tags3, l2Tags4, ['Sap', 'Snap' ] ]
l2TagsNonArpa = [ l2Tags1, l2Tags2, l2Tags3, l2Tags4, ['Sap', 'Snap' ] ]
l2TagCombinations = cross2( l2TagsNonArpa )
for l2Tag in l2TagCombinations:
	tagCombination = ['Eth', l2Tag ]
	if l2Checks(l2Tag):
		tagCombination = ['Eth', l2Tag ]
		if printPktTypes:
			print flatten( tagCombination )
		totalCombinations += 1
		if 'SNAP' in l2Tag:
			tagCombination = ['Eth', l2Tag, 'Ipv4' ]
			if printPktTypes:
				print flatten( tagCombination )
			tagCombination = ['Eth', l2Tag, 'Ipv6' ]
			if printPktTypes:
				print flatten( tagCombination )
			totalCombinations += 2

print "Total including SAP, SNAP Combinations %d \n" % totalCombinations

# Mac-in-Mac combinations
#l2Tags1 = [ (), 'MacSec8', 'MacSec16' ]
l2Tags7 = [ (), 'Sil Tag1q', 'Fch' ]
#  ['Itag', 'Btag Itag']
#l2Tags4 = [ (), 'L2Cmd'  ]
#l2Tags6 = [ (), 'L2Sia' ]

l2TagsMim = [ l2Tags1, l2Tags7, ['Itag', 'Btag Itag'], l2Tags4, l2Tags6 ]
l2TagCombinations = cross2( l2TagsMim );
for l2Tag in l2TagCombinations:
	tagCombination = ['Eth', l2Tag, 'InnerEth' ]
	if l2Checks(l2Tag):
		totalCombinations += 1
		if printPktTypes:
			print flatten( tagCombination )

print "Total including Mac-in-Mac Combinations %d \n" % totalCombinations
