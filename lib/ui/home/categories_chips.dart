import 'package:craftbeer/abstractions/category_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/providers/brewer_provider.dart';
import 'package:craftbeer/providers/categories_provider.dart';
import 'package:craftbeer/ui/components/beer_card.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesChips extends StatelessWidget {
  final Function scrollOnTap;

  const CategoriesChips({Key key, this.scrollOnTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var categoriesData = Provider.of<CategoriesData>(context);
    if (categoriesData.loadingState) {
      return LoadingWidget();
    }
    if (categoriesData.categories == null ||
        categoriesData.categories.isEmpty) {
      return Text(
        S.of(context).empty_state_categories,
        style: TextStyle(color: Colors.grey[500]),
      );
    }
    return Column(
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          direction: Axis.horizontal,
          children: categoriesData?.categories
              ?.map((category) => CategoryChip(
                  name: category.name,
                  quantity: category.beersIds?.length ?? 0,
                  onTapCallBack: () {
                    categoriesData.updateSelection(category);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      scrollOnTap();
                    });
                  }))
              ?.toList(),
        ),
        SizedBox(
          height: kBigMargin,
        ),
        categoriesData.selectedCategory != null
            ? FilterBeersByTypeView(
                selectedCategory: categoriesData.selectedCategory,
              )
            : SizedBox(
                height: 0.0,
              ),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String name;
  final int quantity;
  final Function onTapCallBack;

  CategoryChip(
      {@required this.name,
      @required this.quantity,
      @required this.onTapCallBack});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCallBack,
      child: Chip(
        backgroundColor: kGreenColor,
        label: RichText(
          textAlign: TextAlign.center,
          text: quantity != 0
              ? TextSpan(
                  style: TextStyle(
                      color: kWhiteColor, fontWeight: FontWeight.bold),
                  children: [
                      TextSpan(
                        text: name,
                      ),
                      TextSpan(text: " "),
                      TextSpan(
                        text: quantity.toString(),
                      )
                    ])
              : TextSpan(
                  style: TextStyle(color: kZelyonyGreenLightColor),
                  children: [
                      TextSpan(text: name),
                    ]),
        ),
      ),
    );
  }
}

class FilterBeersByTypeView extends StatelessWidget {
  final BeerType selectedCategory;

  FilterBeersByTypeView({this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Consumer<BrewersData>(
      builder: (context, brewerData, child) => FutureBuilder(
          future: brewerData.fetchBeersByCategory(selectedCategory.beersIds),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.length > 0) {
              return Container(
                  height: kBeerCardHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length ?? 0,
                    itemBuilder: (context, index) =>
                        BeerCard(beer: snapshot.data[index]),
                  ));
            } else {
              return SizedBox(
                height: 0,
              );
            }
          }),
    );
  }
}
