package hkssprangers.browser;

import mui.core.*;
import js.Browser.*;
import js.lib.Promise;
import hkssprangers.StaticResource;

typedef IndexSplideProps = {}
typedef IndexSplideState = {}

class IndexSplide extends ReactComponentOf<IndexSplideProps, IndexSplideState> {
    static final items = [
        {
            title: "梅貴緣糕點預訂",
            url: "https://docs.google.com/forms/d/e/1FAIpQLSenLJEbpw4-IDRZdGKQs2wERhYF-jFv0uVxx8WQ-UuVJPlTPQ/viewform",
            img: StaticResource.image("/images/2022-cake-43.jpg", "梅貴緣糕點預訂", "w-100 my-3"),
        },
        {
            title: "賀年美酒速遞",
            url: "https://docs.google.com/forms/d/e/1FAIpQLSeGTMjsQNdySCu7RpYIJ3zjHSNE1p3u01dfBIEYa2i7u5AHrg/viewform",
            img: StaticResource.image("/images/wine2022-cny.jpg", "賀年美酒速遞", "w-100 my-3"),
        },
        {
            title: "Hyginova年廿八洗邋遢",
            url: "https://docs.google.com/forms/d/e/1FAIpQLSebHaeo7cEqGTsNKSBk7s27Jlok4WSLJJc2IRoZa39A6TrAiw/viewform",
            img: StaticResource.image("/images/hyginova43.jpg", "Hyginova年廿八洗邋遢", "w-100 my-3"),
        },
    ];

    static final options = {
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
          "640": {
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
                            立即落單
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