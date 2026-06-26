#!/usr/bin/env python3
"""Candidate figures for transport diagnostics and denominator framing.

The figures use Brett's central house-style matplotlib settings and write both
PDF and PNG outputs to data/derived/figures.
"""

from pathlib import Path
import sys

import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
DERIVED = ROOT / "data" / "derived"
FIGURES = DERIVED / "figures"
FIGURES.mkdir(parents=True, exist_ok=True)

HOUSE_STYLE = (ROOT / ".house-style" / "preamble.tex").resolve().parent
sys.path.insert(0, str(HOUSE_STYLE))
from plot_style import COLORS, add_grid, save_figure, setup  # noqa: E402


TEXT_COLORS = {
    "secondary": "#C74F41",
    "tertiary": "#3D825D",
    "quaternary": "#946697",
    "quinary": "#94702B",
    "accent": "#4B7AA1",
}


def read_derived(name: str) -> pd.DataFrame:
    path = DERIVED / name
    if not path.exists():
        raise FileNotFoundError(f"Missing derived file: {path}")
    return pd.read_csv(path)


def save(fig: plt.Figure, name: str) -> None:
    fig.tight_layout()
    save_figure(fig, FIGURES / name, formats=("pdf", "png"))
    plt.close(fig)


def percent_label(value: float) -> str:
    return f"{100 * value:.0f}%"


def mention(verb: str) -> str:
    """House-style mention: render a cited verb form in serif italic.

    The figures are matplotlib, so \\mention maps to italic mathtext. Counts and
    other roman text outside the math span stay upright.
    """
    return rf"$\mathit{{{verb}}}$"


def make_transport_metrics(metrics: pd.DataFrame) -> None:
    labels = {
        "source_marginal": "source\nmarginal",
        "source_verb_only": "source\nverb only",
        "source_nonverb": "source\nnon-verb",
        "source_full_core": "source\nfull",
        "native_oof_marginal": "native\nmarginal",
        "native_oof_nonverb": "native\nnon-verb",
        "native_oof_full_core": "native\nfull",
    }
    ordered = list(labels)
    data = metrics[metrics["model"].isin(ordered)].copy()
    data["label"] = pd.Categorical(
        data["model"].map(labels),
        categories=[labels[item] for item in ordered],
        ordered=True,
    )
    data = data.sort_values("label")

    fills = [
        COLORS["light"],
        TEXT_COLORS["accent"],
        TEXT_COLORS["tertiary"],
        COLORS["primary"],
        TEXT_COLORS["secondary"],
        TEXT_COLORS["quaternary"],
        TEXT_COLORS["quinary"],
    ]

    fig, axes = plt.subplots(1, 2, figsize=(8.2, 3.6))
    for ax, column, xlabel, xmax in [
        (axes[0], "test_log_loss", "Log loss (lower is better)", 0.95),
        (
            axes[1],
            "test_auc",
            "Area under receiver operating characteristic\ncurve (higher is better)",
            1.0,
        ),
    ]:
        y = range(len(data))
        ax.barh(y, data[column], color=fills, edgecolor="none")
        ax.set_yticks(y, data["label"])
        ax.invert_yaxis()
        ax.set_xlim(0, xmax)
        ax.set_xlabel(xlabel)
        add_grid(ax, axis="x")
        for ypos, value in zip(y, data[column]):
            ax.text(value + xmax * 0.015, ypos, f"{value:.3f}",
                    va="center", color=COLORS["dark"], fontsize=8)
    save(fig, "bnc2014_transport_metrics_core")


def make_observed_np_rate(verb_counts: pd.DataFrame) -> None:
    data = verb_counts.copy()
    data["np_rate"] = data["VNN"] / data["total"]
    data = data.sort_values("np_rate")

    fig, ax = plt.subplots(figsize=(5.8, 3.5))
    y = range(len(data))
    ax.barh(y, data["np_rate"], color=COLORS["primary"], edgecolor="none")
    ax.set_yticks(y, [mention(v) for v in data["Verb"]])
    ax.set_xlim(0, 1)
    ax.set_xlabel("Observed noun phrase (NP) recipient rate")
    ax.set_ylabel("Verb")
    add_grid(ax, axis="x")
    for ypos, row in zip(y, data.itertuples()):
        ax.text(row.np_rate + 0.025, ypos, f"{percent_label(row.np_rate)}; n={row.total}",
                va="center", fontsize=8, color=COLORS["dark"])
    save(fig, "bnc2014_observed_np_rate_by_verb")


def calibration_panel(ax, data: pd.DataFrame, colour: str, title: str) -> None:
    data = data.copy()
    x = list(range(len(data)))
    tick_labels = [f"{mention(row.group)}\nn={row.n}" for row in data.itertuples()]

    ax.vlines(x, data["observed"], data["predicted"], color="#9A9A9A", linewidth=0.7)
    lower = data["observed"] - data["observed_lo"]
    upper = data["observed_hi"] - data["observed"]
    ax.errorbar(
        x,
        data["observed"],
        yerr=[lower, upper],
        color=COLORS["dark"],
        marker="o",
        linestyle="none",
        capsize=2.8,
        linewidth=0.8,
        label="observed",
    )
    ax.plot(x, data["predicted"], color=colour, marker="^", linestyle="--",
            label="predicted")
    ax.set_title(title)
    ax.set_xticks(x, tick_labels)
    ax.set_ylim(0, 1)
    ax.set_xlim(-0.35, len(data) - 0.35)
    ax.set_xlabel("Verb")
    add_grid(ax, axis="y")

    last_x = x[-1] + 0.12
    observed_y = data["observed"].iloc[-1]
    predicted_y = data["predicted"].iloc[-1]
    if abs(observed_y - predicted_y) < 0.05:
        observed_y += 0.035
        predicted_y -= 0.035
    ax.text(last_x, observed_y, "observed",
            va="center", fontsize=8, color=COLORS["dark"])
    ax.text(last_x, predicted_y, "predicted",
            va="center", fontsize=8, color=colour)


def make_calibration(calibration: pd.DataFrame) -> None:
    model_names = {
        "source_full_core": "Transported source full model",
        "native_oof_full_core": "BNC2014-native out-of-fold model",
    }
    verb_order = ["give", "show", "offer", "lend", "send", "sell"]
    data = calibration[calibration["model"].isin(model_names)].copy()
    data["group"] = pd.Categorical(data["group"], categories=verb_order, ordered=True)
    data = data.sort_values(["model", "group"])

    fig, axes = plt.subplots(1, 2, figsize=(8.4, 3.6), sharey=True)
    calibration_panel(
        axes[0],
        data[data["model"] == "source_full_core"],
        COLORS["primary"],
        model_names["source_full_core"],
    )
    axes[0].set_ylabel("Noun phrase (NP) recipient rate")
    calibration_panel(
        axes[1],
        data[data["model"] == "native_oof_full_core"],
        TEXT_COLORS["quaternary"],
        model_names["native_oof_full_core"],
    )
    save(fig, "bnc2014_transport_calibration_by_verb")


def make_calibration_error(calibration: pd.DataFrame) -> None:
    selected = {
        "source_full_core": ("source full transport", COLORS["primary"]),
        "native_oof_full_core": ("BNC2014 native OOF", TEXT_COLORS["quaternary"]),
    }
    verb_order = ["give", "show", "offer", "lend", "send", "sell"]
    data = calibration[calibration["model"].isin(selected)].copy()
    data["group"] = pd.Categorical(data["group"], categories=verb_order, ordered=True)
    data["error"] = data["predicted"] - data["observed"]
    data = data.sort_values(["model", "group"])
    lim = max(abs(data["error"].min()), abs(data["error"].max())) + 0.08

    fig, axes = plt.subplots(1, 2, figsize=(8.2, 3.4), sharex=True, sharey=True)
    for ax, (model, (title, colour)) in zip(axes, selected.items()):
        rows = data[data["model"] == model].sort_values("group")
        y = range(len(rows))
        ax.axvline(0, color=COLORS["dark"], linewidth=0.8)
        ax.hlines(y, 0, rows["error"], color="#9A9A9A", linewidth=0.8)
        ax.plot(rows["error"], y, marker="o", color=colour, linestyle="none")
        ax.set_yticks(y, [mention(g) for g in rows["group"]])
        ax.invert_yaxis()
        ax.set_xlim(-lim, lim)
        ax.set_title(title)
        ax.set_xlabel("Predicted minus observed NP rate")
        add_grid(ax, axis="x")
        for ypos, row in zip(y, rows.itertuples()):
            offset = 0.012 if row.error >= 0 else -0.012
            ha = "left" if row.error >= 0 else "right"
            ax.text(row.error + offset, ypos, f"{row.error:+.2f}",
                    va="center", ha=ha, fontsize=8, color=COLORS["dark"],
                    clip_on=False)
    axes[0].set_ylabel("Verb")
    save(fig, "bnc2014_transport_calibration_error_by_verb")


def add_box(ax, xy, width, height, face, edge, title, subtitle=None) -> None:
    ax.add_patch(
        Rectangle(
            xy,
            width,
            height,
            facecolor=face,
            edgecolor=edge,
            linewidth=1.2,
        )
    )
    x, y = xy
    ax.text(x + 0.18, y + height - 0.28, title, va="top",
            ha="left", fontsize=10, fontweight="semibold", color=COLORS["dark"])
    if subtitle:
        ax.text(x + 0.18, y + height - 0.68, subtitle, va="top",
                ha="left", fontsize=8.5, color=COLORS["dark"])


def make_opportunity_sets() -> None:
    fig, ax = plt.subplots(figsize=(8.2, 4.8))
    ax.set_xlim(0, 12)
    ax.set_ylim(0, 8)
    ax.axis("off")

    ax.text(0.45, 7.72, "Production corpus channel", fontsize=11,
            fontweight="semibold", color=COLORS["dark"])
    add_box(
        ax,
        (0.45, 0.55),
        6.55,
        6.95,
        "#F7F7F7",
        COLORS["dark"],
        "D2: transfer-event expressions",
        "semantic/event denominator",
    )
    add_box(
        ax,
        (0.90, 1.15),
        5.65,
        4.95,
        "#E6EFF6",
        COLORS["primary"],
        "D1: six-verb candidate tokens",
        "recoverable if source queries are available",
    )
    add_box(
        ax,
        (1.35, 1.65),
        4.75,
        3.35,
        "#F8E4E0",
        TEXT_COLORS["secondary"],
        "D0: annotated noun phrase/prepositional phrase rows",
        "released rows analyzed here",
    )
    add_box(
        ax,
        (1.85, 2.15),
        3.75,
        1.50,
        "#F7EBD3",
        TEXT_COLORS["quinary"],
        "Chosen realization",
        "noun phrase (NP) vs prepositional phrase (PP)",
    )

    ax.text(8.10, 7.72, "Judgement evidence channel", fontsize=11,
            fontweight="semibold", color=COLORS["dark"])
    add_box(
        ax,
        (8.10, 5.80),
        3.35,
        1.15,
        "#EEF0F5",
        TEXT_COLORS["quaternary"],
        "D3: constructed alternatives",
        "judgement opportunity set",
    )
    add_box(
        ax,
        (8.10, 3.55),
        3.35,
        1.15,
        "#FFFFFF",
        TEXT_COLORS["quaternary"],
        "Judgement responses",
        "noisy, role-dependent instrument",
    )
    add_box(
        ax,
        (8.10, 1.30),
        3.35,
        1.15,
        "#FFFFFF",
        COLORS["dark"],
        "Grammaticality",
        "community-conditioned licensing status",
    )

    arrow = dict(arrowstyle="->", color=TEXT_COLORS["quaternary"],
                 linewidth=1.2, shrinkA=4, shrinkB=4, linestyle="--")
    ax.annotate("", xy=(9.78, 4.74), xytext=(9.78, 5.78), arrowprops=arrow)
    ax.annotate("", xy=(9.78, 2.49), xytext=(9.78, 3.53), arrowprops=arrow)
    ax.text(10.05, 5.23, "elicited response", fontsize=8.2,
            color=TEXT_COLORS["quaternary"], va="center", ha="left")
    ax.text(10.05, 3.00, "inferential support", fontsize=8.2,
            color=TEXT_COLORS["quaternary"], va="center", ha="left")
    ax.annotate(
        "",
        xy=(7.85, 3.00),
        xytext=(6.82, 3.00),
        arrowprops=dict(arrowstyle="->", color=COLORS["dark"], linewidth=1.0),
    )
    ax.text(6.90, 3.22, "separate evidence channel", fontsize=8.5,
            color=COLORS["dark"], ha="left")
    ax.text(
        0.45,
        0.22,
        "The corpus denominator narrows before the model estimates NP/PP choice.",
        fontsize=9,
        color=COLORS["dark"],
    )
    save(fig, "opportunity_sets_nested")


def make_dais_bridge(scored_items: pd.DataFrame) -> None:
    data = scored_items[scored_items["coding"] == "something_pronominal"].copy()
    if data.empty:
        raise ValueError("No DAIS scored items with coding == something_pronominal")

    verb_order = ["give", "show", "offer", "lend", "send", "sell"]
    verb_colours = {
        "give": COLORS["primary"],
        "show": TEXT_COLORS["tertiary"],
        "offer": TEXT_COLORS["secondary"],
        "lend": TEXT_COLORS["quaternary"],
        "send": TEXT_COLORS["accent"],
        "sell": TEXT_COLORS["quinary"],
    }

    fig, ax = plt.subplots(figsize=(5.9, 4.2))
    ax.plot([0, 1], [0, 1], color="#9A9A9A", linewidth=0.9,
            linestyle="--", zorder=1)

    for verb in verb_order:
        rows = data[data["Verb"] == verb]
        is_offer = verb == "offer"
        ax.scatter(
            rows["production_np_prob"],
            rows["human_do_preference"],
            s=42 if is_offer else 30,
            color=verb_colours[verb],
            alpha=0.88 if is_offer else 0.68,
            edgecolor=COLORS["dark"] if is_offer else "white",
            linewidth=0.65 if is_offer else 0.35,
            label=mention(verb),
            zorder=3 if is_offer else 2,
        )

    offer_mean = data[data["Verb"] == "offer"][
        ["production_np_prob", "human_do_preference"]
    ].mean()
    ax.annotate(
        mention("offer"),
        xy=(offer_mean["production_np_prob"], offer_mean["human_do_preference"]),
        xytext=(0.24, 0.66),
        arrowprops=dict(arrowstyle="->", color=TEXT_COLORS["secondary"],
                        linewidth=1.0, shrinkA=3, shrinkB=3),
        color=TEXT_COLORS["secondary"],
        fontsize=10,
    )

    ax.set_xlim(-0.02, 1.02)
    ax.set_ylim(-0.02, 1.02)
    ax.set_xlabel("Production model NP probability")
    ax.set_ylabel("DAIS double-object preference")
    add_grid(ax, axis="both")
    ax.legend(
        title="Verb",
        loc="lower right",
        frameon=False,
        ncol=2,
        handletextpad=0.25,
        columnspacing=0.8,
    )
    save(fig, "dais_production_preference_bridge")


def main() -> None:
    setup(font_size=10, title_size=11, tick_size=9, legend_size=9)
    # Serif mathtext so \mention-style italic verbs match the body font.
    plt.rcParams.update({
        "mathtext.fontset": "custom",
        "mathtext.rm": "serif",
        "mathtext.it": "serif:italic",
        "mathtext.bf": "serif:bold",
    })
    make_transport_metrics(read_derived("bnc2014_paired_transport_cv_metrics.csv"))
    make_observed_np_rate(read_derived("bnc2014_dative_verb_pattern_counts.csv"))
    calibration = read_derived("bnc2014_paired_transport_cv_calibration_by_verb.csv")
    make_calibration(calibration)
    make_calibration_error(calibration)
    make_dais_bridge(read_derived("dais_acceptability_bridge_scored_items.csv"))
    make_opportunity_sets()


if __name__ == "__main__":
    main()
