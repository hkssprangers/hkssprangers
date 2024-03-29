package hkssprangers.browser;

import mui.core.*;
import js.Browser.*;
import js.lib.Promise;
import hkssprangers.StaticResourceMacros.*;

typedef IndexSplideProps = {}
typedef IndexSplideState = {}

class IndexSplide extends ReactComponentOf<IndexSplideProps, IndexSplideState> {
    static final items = [
        {
            title: "埗兵週末本地菜群組",
            url: "https://t.me/+uHQZCJagi5E3NTk1",
            img: image("/images/banner-vege.jpg", "埗兵週末本地菜群組 x 歐羅農場", "w-100 my-3 rounded-md"),
            button: "立即加入"
        },
        {
            title: "埗兵咖啡渣之旅",
            url: "/food-waste-recycle",
            img: image("/images/food-waste-recycle/banner-food-waste-recycle.jpg", "埗兵咖啡渣之旅", "w-100 my-3 rounded-md"),
            button: "了解更多"
        },
        {
            title: "誠徵佛系(兼職)外賣員",
            url: "https://docs.google.com/forms/d/e/1FAIpQLSfb9cyDbHckv1Obs9_8Wju8cLDAfYDXO6IcAT0EPLq8cpK8wQ/viewform",
            img: image("/images/banner-recruit.jpg", "埗兵招人", "w-100 my-3 rounded-md"),
            button: "了解更多"
        },
        {
            title: "Hyginova 環保消毒除臭噴霧",
            url: "https://docs.google.com/forms/d/e/1FAIpQLSebHaeo7cEqGTsNKSBk7s27Jlok4WSLJJc2IRoZa39A6TrAiw/viewform",
            img: image("/images/hyginova43.jpg", "Hyginova 環保消毒除臭噴霧", "w-100 my-3 rounded-md"),
            button: "立即落單"
        },
    ];

    static final options:splidejs.splide.Options = {
        type: 'loop',
        autoplay: true,
        interval: 8000.0,
        pagination: false,
        perPage: 2.0,
        perMove: 2.0,
        padding: {
          left: '10%',
          right: '10%'
        },
        breakpoints: {
          "720": {
            perPage: 1.0,
            perMove: 1.0,
            padding: {
              left: '10%',
              right: '10%'
            }
          },
        }
    }

    static final Splide:Class<ReactComponentOf<splidejs.react_splide.SplideProps,{}>> = cast splidejs.react_splide.Splide;
    static final SplideSlide:Class<ReactComponentOf<{},{}>> = cast splidejs.ReactSplide.SplideSlide;

    function new(props) {
        super(props);
    }

    override function render():ReactFragment {
        final splides = [
            for (item in items)
            jsx('
                <SplideSlide>
                    <div className="p-3">
                        <div className="flex">
                            ${item.title}
                        <div className="flex-1 ml-3 bg-border-black" >&nbsp;</div>
                        </div>
                        <a href="${item.url}">${item.img}</a>
                        <a className="py-3 px-6 flex items-center justify-center rounded-md border border-black focus:ring-2" href="${item.url}">
                            ${item.button}
                        </a>
                    </div>
                </SplideSlide>
            ')
        ];
        return jsx('
            <Splide options=${options}>${splides}</Splide>
        ');
    }
}