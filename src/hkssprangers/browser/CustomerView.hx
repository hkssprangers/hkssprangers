package hkssprangers.browser;

import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import js.npm.material_ui.MaterialUi;
import hkssprangers.info.Info;

class CustomerView extends ReactComponent {
    override function render() {
        return jsx('
            <Container maxWidth="sm">
                <Grid container=${true} spacing=${1}>
                    <Grid item=${true} xs=${12}>
                        <Typography >落單</Typography>
                    </Grid>
                    <Grid item=${true} container=${true} xs=${12} spacing=${3} justify="center">
                        <Grid item=${true}>
                            <Button
                                color="primary"
                                href="https://docs.google.com/forms/d/e/1FAIpQLSfKw5JY0no7Tgu7q0hT2LP05rJ23DCMRIcCjxfwyapfSMl-Bg/viewform"
                            >
                                ${YearsHK.info().name}
                            </Button>
                        </Grid>
                        <Grid item=${true}>
                            <Button
                                color="primary"
                                href="https://docs.google.com/forms/d/e/1FAIpQLSc48HZ4IZrZNM-LXBOf7NhrV2BGqlvqHBnAKodh4u4R5e283A/viewform"
                            >
                                ${EightyNine.info().name}
                            </Button>
                        </Grid>
                        <Grid item=${true}>
                            <Button
                                color="primary"
                                href="https://docs.google.com/forms/d/e/1FAIpQLSfvb1PDjceErVgyogijVDxkN3pXu0djpBFzc_H59oqrdSH0mQ/viewform"
                            >
                                ${DragonJapaneseCuisine.info().name}
                            </Button>
                        </Grid>
                        <Grid item=${true}>
                            <Button
                                color="primary"
                                href="https://docs.google.com/forms/u/1/d/e/1FAIpQLSffligA-KWnAQsNPbshjYFJeE8s00XkKoXP0IbUYd0xZReotg/viewform"
                            >
                                ${LaksaStore.info().name}
                            </Button>
                        </Grid>
                    </Grid>
                </Grid>
            </Container>
        ');
    }
}