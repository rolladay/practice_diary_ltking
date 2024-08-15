import 'package:flutter/material.dart';

double bnbItemSize = 36;

final myBnbList = [
  BottomNavigationBarItem(
    icon: Image.asset('assets/images/bnb_rank_unselect.png', width: bnbItemSize,),
    activeIcon: Image.asset('assets/images/bnb_rank_select.png', width: bnbItemSize,),
    label: 'Rank',
  ),
  BottomNavigationBarItem(
    icon: Image.asset('assets/images/bnb_lotto_unselect.png', width: bnbItemSize,),
    activeIcon: Image.asset('assets/images/bnb_lotto_select.png', width: bnbItemSize,),
    label: 'Lotto',
  ),
  BottomNavigationBarItem(
    icon: Image.asset('assets/images/bnb_store_unselect.png', width: bnbItemSize,),
    activeIcon: Image.asset('assets/images/bnb_store_select.png', width: bnbItemSize,),
    label: 'Draw',
  ),
  BottomNavigationBarItem(
    icon: Image.asset('assets/images/bnb_profile_unselect.png', width: bnbItemSize,),
    activeIcon: Image.asset('assets/images/bnb_profile_select.png', width: bnbItemSize,),
    label: 'Profile',

  ),
];

